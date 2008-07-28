Return-Path: <linux-kernel-owner+w=401wt.eu-S1759373AbYG1Ri4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373AbYG1Ri4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 13:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbYG1Ris
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 13:38:48 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:39411 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbYG1Rir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 13:38:47 -0400
Date: Mon, 28 Jul 2008 10:37:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Calvin Walton <calvin.walton@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] FILESYSTEMS: Make "advanced partitions" immediately
 unselectable.
Message-Id: <20080728103731.7bafd577.randy.dunlap@oracle.com>
In-Reply-To: <alpine.LFD.1.10.0807280531210.3402@localhost.localdomain>
References: <alpine.LFD.1.10.0807241135540.5289@localhost.localdomain>
	<20080726094718.b617c1e7.randy.dunlap@oracle.com>
	<alpine.LFD.1.10.0807261750340.3493@localhost.localdomain>
	<1217214689.22927.3.camel@zem.phub.net.cable.rogers.com>
	<alpine.LFD.1.10.0807280531210.3402@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>   yes, it's nitpicking but, as it's laid out right now, it's
> unnecessarily confusing and inconsistent.  but i don't know if there's
> a trivial fix for it.

Yes, I'd call MSDOS partitions basic, not Advanced, and then put all others
under an Advanced menu that can be toggled on/off easily with menuconfig.

Not quite trivial, but not messy either.

Patch below.  Comments?
---

From: Randy Dunlap <randy.dunlap@oracle.com>

Use "menuconfig" to allow all advanced partitions to be deselectable
from the FS partitions menu.
However, leave MSDOS_PARTITION as a basic partition type (i.e.,
not advanced), so that its "default y" remains in effect.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---

 fs/Kconfig            |    6 ----
 fs/partitions/Kconfig |   72 ++++++++++++++++++++++++++++----------------------
 2 files changed, 41 insertions(+), 37 deletions(-)

--- lin2626-g9-kerndoc.orig/fs/Kconfig
+++ lin2626-g9-kerndoc/fs/Kconfig
@@ -2142,14 +2142,8 @@ config 9P_FS
 
 endif # NETWORK_FILESYSTEMS
 
-if BLOCK
-menu "Partition Types"
-
 source "fs/partitions/Kconfig"
 
-endmenu
-endif
-
 source "fs/nls/Kconfig"
 source "fs/dlm/Kconfig"
 
--- lin2626-g9-kerndoc.orig/fs/partitions/Kconfig
+++ lin2626-g9-kerndoc/fs/partitions/Kconfig
@@ -1,8 +1,19 @@
 #
 # Partition configuration
 #
-config PARTITION_ADVANCED
-	bool "Advanced partition selection"
+
+if BLOCK
+
+menu "Partition types"
+
+config MSDOS_PARTITION
+	bool "PC BIOS (MSDOS partition tables) support"
+	default y
+	help
+	  Say Y here.
+
+menuconfig PARTITION_ADVANCED
+	bool "Advanced partition support"
 	help
 	  Say Y here if you would like to use hard disks under Linux which
 	  were partitioned under an operating system running on a different
@@ -14,14 +25,16 @@ config PARTITION_ADVANCED
 
 	  If unsure, say N.
 
+if PARTITION_ADVANCED
+
 config ACORN_PARTITION
-	bool "Acorn partition support" if PARTITION_ADVANCED
+	bool "Acorn partition support"
 	default y if ARCH_ACORN
 	help
 	  Support hard disks partitioned under Acorn operating systems.
 
 config ACORN_PARTITION_CUMANA
-	bool "Cumana partition support" if PARTITION_ADVANCED
+	bool "Cumana partition support"
 	default y if ARCH_ACORN
 	depends on ACORN_PARTITION
 	help
@@ -29,12 +42,12 @@ config ACORN_PARTITION_CUMANA
 	  were partitioned using the Cumana interface on Acorn machines.
 
 config ACORN_PARTITION_EESOX
-	bool "EESOX partition support" if PARTITION_ADVANCED
+	bool "EESOX partition support"
 	default y if ARCH_ACORN
 	depends on ACORN_PARTITION
 
 config ACORN_PARTITION_ICS
-	bool "ICS partition support" if PARTITION_ADVANCED
+	bool "ICS partition support"
 	default y if ARCH_ACORN
 	depends on ACORN_PARTITION
 	help
@@ -42,7 +55,7 @@ config ACORN_PARTITION_ICS
 	  were partitioned using the ICS interface on Acorn machines.
 
 config ACORN_PARTITION_ADFS
-	bool "Native filecore partition support" if PARTITION_ADVANCED
+	bool "Native filecore partition support"
 	default y if ARCH_ACORN
 	depends on ACORN_PARTITION
 	help
@@ -52,7 +65,7 @@ config ACORN_PARTITION_ADFS
 	  `Y' here, Linux will support disk partitions created under ADFS.
 
 config ACORN_PARTITION_POWERTEC
-	bool "PowerTec partition support" if PARTITION_ADVANCED
+	bool "PowerTec partition support"
 	default y if ARCH_ACORN
 	depends on ACORN_PARTITION
 	help
@@ -60,7 +73,7 @@ config ACORN_PARTITION_POWERTEC
 	  the PowerTec SCSI drive.
 
 config ACORN_PARTITION_RISCIX
-	bool "RISCiX partition support" if PARTITION_ADVANCED
+	bool "RISCiX partition support"
 	default y if ARCH_ACORN
 	depends on ACORN_PARTITION
 	help
@@ -69,21 +82,21 @@ config ACORN_PARTITION_RISCIX
 	  to read disks partitioned under RISCiX.
 
 config OSF_PARTITION
-	bool "Alpha OSF partition support" if PARTITION_ADVANCED
+	bool "Alpha OSF partition support"
 	default y if ALPHA
 	help
 	  Say Y here if you would like to use hard disks under Linux which
 	  were partitioned on an Alpha machine.
 
 config AMIGA_PARTITION
-	bool "Amiga partition table support" if PARTITION_ADVANCED
+	bool "Amiga partition table support"
 	default y if (AMIGA || AFFS_FS=y)
 	help
 	  Say Y here if you would like to use hard disks under Linux which
 	  were partitioned under AmigaOS.
 
 config ATARI_PARTITION
-	bool "Atari partition table support" if PARTITION_ADVANCED
+	bool "Atari partition table support"
 	default y if ATARI
 	help
 	  Say Y here if you would like to use hard disks under Linux which
@@ -91,28 +104,22 @@ config ATARI_PARTITION
 
 config IBM_PARTITION
 	bool "IBM disk label and partition support"
-	depends on PARTITION_ADVANCED && S390
+	depends on S390
 	help
 	  Say Y here if you would like to be able to read the hard disk
 	  partition table format used by IBM DASD disks operating under CMS.
 	  Otherwise, say N.
 
 config MAC_PARTITION
-	bool "Macintosh partition map support" if PARTITION_ADVANCED
+	bool "Macintosh partition map support"
 	default y if (MAC || PPC_PMAC)
 	help
 	  Say Y here if you would like to use hard disks under Linux which
 	  were partitioned on a Macintosh.
 
-config MSDOS_PARTITION
-	bool "PC BIOS (MSDOS partition tables) support" if PARTITION_ADVANCED
-	default y
-	help
-	  Say Y here.
-
 config BSD_DISKLABEL
 	bool "BSD disklabel (FreeBSD partition tables) support"
-	depends on PARTITION_ADVANCED && MSDOS_PARTITION
+	depends on MSDOS_PARTITION
 	help
 	  FreeBSD uses its own hard disk partition scheme on your PC. It
 	  requires only one entry in the primary partition table of your disk
@@ -125,7 +132,7 @@ config BSD_DISKLABEL
 
 config MINIX_SUBPARTITION
 	bool "Minix subpartition support"
-	depends on PARTITION_ADVANCED && MSDOS_PARTITION
+	depends on MSDOS_PARTITION
 	help
 	  Minix 2.0.0/2.0.2 subpartition table support for Linux.
 	  Say Y here if you want to mount and use Minix 2.0.0/2.0.2
@@ -133,7 +140,7 @@ config MINIX_SUBPARTITION
 
 config SOLARIS_X86_PARTITION
 	bool "Solaris (x86) partition table support"
-	depends on PARTITION_ADVANCED && MSDOS_PARTITION
+	depends on MSDOS_PARTITION
 	help
 	  Like most systems, Solaris x86 uses its own hard disk partition
 	  table format, incompatible with all others. Saying Y here allows you
@@ -143,7 +150,7 @@ config SOLARIS_X86_PARTITION
 
 config UNIXWARE_DISKLABEL
 	bool "Unixware slices support"
-	depends on PARTITION_ADVANCED && MSDOS_PARTITION
+	depends on MSDOS_PARTITION
 	---help---
 	  Like some systems, UnixWare uses its own slice table inside a
 	  partition (VTOC - Virtual Table of Contents). Its format is
@@ -163,7 +170,6 @@ config UNIXWARE_DISKLABEL
 
 config LDM_PARTITION
 	bool "Windows Logical Disk Manager (Dynamic Disk) support"
-	depends on PARTITION_ADVANCED
 	---help---
 	  Say Y here if you would like to use hard disks under Linux which
 	  were partitioned using Windows 2000's/XP's or Vista's Logical Disk
@@ -197,14 +203,14 @@ config LDM_DEBUG
 	  If unsure, say N.
 
 config SGI_PARTITION
-	bool "SGI partition support" if PARTITION_ADVANCED
+	bool "SGI partition support"
 	default y if DEFAULT_SGI_PARTITION
 	help
 	  Say Y here if you would like to be able to read the hard disk
 	  partition table format used by SGI machines.
 
 config ULTRIX_PARTITION
-	bool "Ultrix partition table support" if PARTITION_ADVANCED
+	bool "Ultrix partition table support"
 	default y if MACH_DECSTATION
 	help
 	  Say Y here if you would like to be able to read the hard disk
@@ -212,7 +218,7 @@ config ULTRIX_PARTITION
 	  Otherwise, say N.
 
 config SUN_PARTITION
-	bool "Sun partition tables support" if PARTITION_ADVANCED
+	bool "Sun partition tables support"
 	default y if (SPARC || SUN3 || SUN3X)
 	---help---
 	  Like most systems, SunOS uses its own hard disk partition table
@@ -228,24 +234,28 @@ config SUN_PARTITION
 
 config KARMA_PARTITION
 	bool "Karma Partition support"
-	depends on PARTITION_ADVANCED
 	help
 	  Say Y here if you would like to mount the Rio Karma MP3 player, as it
 	  uses a proprietary partition table.
 
 config EFI_PARTITION
 	bool "EFI GUID Partition support"
-	depends on PARTITION_ADVANCED
 	select CRC32
 	help
 	  Say Y here if you would like to use hard disks under Linux which
 	  were partitioned using EFI GPT.
 
 config SYSV68_PARTITION
-	bool "SYSV68 partition table support" if PARTITION_ADVANCED
+	bool "SYSV68 partition table support"
 	default y if VME
 	help
 	  Say Y here if you would like to be able to read the hard disk
 	  partition table format used by Motorola Delta machines (using
 	  sysv68).
 	  Otherwise, say N.
+
+endif # PARTITION_ADVANCED
+
+endmenu
+
+endif # BLOCK
