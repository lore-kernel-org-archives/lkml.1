Return-Path: <linux-kernel-owner+w=401wt.eu-S1755660AbZDRBdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660AbZDRBdU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 21:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbZDRBdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 21:33:04 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:27518 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbZDRBdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 21:33:03 -0400
Date: Fri, 17 Apr 2009 18:30:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       torvalds <torvalds@linux-foundation.org>,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH] doc: fix kernel-parameters.txt mistaken deletions
Message-Id: <20090417183028.83a1dc04.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A01020A.49E92D09.0093:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Re-add missing kernel-parameters documentation that was accidentally
deleted in commit 0cb55ad2.

Thanks to Ingo and Weidong Han for the heads-up on this.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Ingo Molnar <mingo@elte.hu>
cc: Len Brown <lenb@kernel.org>
---
 Documentation/kernel-parameters.txt |   38 ++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

--- linux-2.6.30-rc2-git3.orig/Documentation/kernel-parameters.txt
+++ linux-2.6.30-rc2-git3/Documentation/kernel-parameters.txt
@@ -231,6 +231,35 @@ and is between 256 and 4096 characters. 
  			power state again in power transition.
  			1 : disable the power state check
 
+	acpi_sci=	[HW,ACPI] ACPI System Control Interrupt trigger mode
+			Format: { level | edge | high | low }
+
+	acpi_serialize	[HW,ACPI] force serialization of AML methods
+
+	acpi_skip_timer_override [HW,ACPI]
+			Recognize and ignore IRQ0/pin2 Interrupt Override.
+			For broken nForce2 BIOS resulting in XT-PIC timer.
+
+	acpi_sleep=	[HW,ACPI] Sleep options
+			Format: { s3_bios, s3_mode, s3_beep, s4_nohwsig,
+				  old_ordering, s4_nonvs }
+			See Documentation/power/video.txt for information on
+			s3_bios and s3_mode.
+			s3_beep is for debugging; it makes the PC's speaker beep
+			as soon as the kernel's real-mode entry point is called.
+			s4_nohwsig prevents ACPI hardware signature from being
+			used during resume from hibernation.
+			old_ordering causes the ACPI 1.0 ordering of the _PTS
+			control method, with respect to putting devices into
+			low power states, to be enforced (the ACPI 2.0 ordering
+			of _PTS is used by default).
+			s4_nonvs prevents the kernel from saving/restoring the
+			ACPI NVS memory during hibernation.
+
+	acpi_use_timer_override [HW,ACPI]
+			Use timer override. For some broken Nvidia NF5 boards
+			that require a timer override, but don't have HPET
+
 	acpi_enforce_resources=	[ACPI]
 			{ strict | lax | no }
 			Check for resource conflicts between native drivers
@@ -250,6 +279,9 @@ and is between 256 and 4096 characters. 
 	ad1848=		[HW,OSS]
 			Format: <io>,<irq>,<dma>,<dma2>,<type>
 
+	add_efi_memmap	[EFI; X86] Include EFI memory map in
+			kernel's map of available physical RAM.
+
 	advansys=	[HW,SCSI]
 			See header of drivers/scsi/advansys.c.
 
@@ -1838,6 +1870,12 @@ and is between 256 and 4096 characters. 
 			autoconfiguration.
 			Ranges are in pairs (memory base and size).
 
+	ports=		[IP_VS_FTP] IPVS ftp helper module
+			Default is 21.
+			Up to 8 (IP_VS_APP_MAX_PORTS) ports
+			may be specified.
+			Format: <port>,<port>....
+
 	print-fatal-signals=
 			[KNL] debug: print fatal signals
 			print-fatal-signals=1: print segfault info to
