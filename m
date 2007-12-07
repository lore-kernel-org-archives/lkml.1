Return-Path: <linux-kernel-owner+w=401wt.eu-S1756817AbXLGTM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbXLGTM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 14:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbXLGTMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 14:12:48 -0500
Received: from s2.ukfsn.org ([217.158.120.143]:35459 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbXLGTMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 14:12:47 -0500
Date: Fri, 7 Dec 2007 19:12:42 +0000
From: Nick Warne <nick@ukfsn.org>
To: linux-kernel@vger.kernel.org
Subject: scsi_wait_scan Kconfig option
Message-ID: <20071207191242.71a9cc3e@linuxamd.linicks.net>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/smTx0+nYPm3kaM.2cBMC9ME"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/smTx0+nYPm3kaM.2cBMC9ME
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


Hi all,

I am bringing this up again - primarily as I forgot about it after
patching my build tree ages ago:

http://lkml.org/lkml/2007/10/27/68

Today I built and installed git for the first time and cloned Linus'
tree (very trick!).

I try not to build a modular kernel, but only have modules ON due to
nVidia (sigh).  So I was semi-surprised when I saw the scsi_wait_scan
module being built again, yet NO WHERE in menuconfig is it present to
turn OFF.  Even if I hand edit .config, make puts it back again...


.config
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m



I have attached my patch again :-)

Nick
-- 
Free Software Foundation Associate Member 5508
--MP_/smTx0+nYPm3kaM.2cBMC9ME
Content-Type: text/x-patch; name=scsi_wait.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=scsi_wait.patch

--- linux-current/drivers/scsi/Kconfig_old	2007-10-20 12:44:50.000000000 +0100
+++ linux-current/drivers/scsi/Kconfig	2007-10-20 12:57:13.000000000 +0100
@@ -248,10 +248,17 @@
 	  or async on the kernel's command line.
 
 config SCSI_WAIT_SCAN
-	tristate
+	tristate "Wait for SCSI scan completion"
 	default m
 	depends on SCSI
 	depends on MODULES
+	help
+	  The SCSI subsystem can probe for devices while the rest of the
+	  system continues booting, and even probe devices on different
+	  busses in parallel, leading to a significant speed-up.
+
+	  You can load the scsi_wait_scan module to ensure that all scans
+	  have completed.
 
 menu "SCSI Transports"
 	depends on SCSI

--MP_/smTx0+nYPm3kaM.2cBMC9ME--
