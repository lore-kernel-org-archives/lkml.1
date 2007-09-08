Return-Path: <linux-kernel-owner+w=401wt.eu-S1752850AbXIHDv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbXIHDv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 23:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbXIHDvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 23:51:50 -0400
Received: from [212.12.190.179] ([212.12.190.179]:32898 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751255AbXIHDvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 23:51:48 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: sata & scsi suggestion for make menuconfig
Date: Sat, 8 Sep 2007 06:52:02 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709080652.02614.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
>> Ok, but that's not the most common situaties. What I'm suggesting is a
>> warning or a please note popup. Not neccessarily an error or refusing to
>> continue thing.
>
>What IMHO makes sense is changing all references to SCSI CDROM,
>SCSI DISK etc. to just CDROM, DISK, and changing SCSI (menu) to
>something like MASS STORAGE.

I once sent a patch to make libata a submenu of scsi.

[PATCH] libata Kconfig: Allow libata to be selected from within the SCSI submenu
From: Al Boldi <a1426z@gawab.com>
To: linux-ide@vger.kernel.org
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Date: 08/01/07 07:22 am

Move libata Kconfig sourcing from the drivers Kconfig into the SCSI Kconfig.

This allows the user to quickly select additional disk/tape/cdrom support 
from within the same menu.

Signed-off-by: Al Boldi <a1426z@gawab.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
--- a/drivers/Kconfig   2007-05-02 17:25:30.000000000 +0300
+++ b/drivers/Kconfig   2007-08-01 06:33:13.000000000 +0300
@@ -22,8 +22,6 @@ source "drivers/ide/Kconfig"
 
 source "drivers/scsi/Kconfig"
 
-source "drivers/ata/Kconfig"
-
 source "drivers/cdrom/Kconfig"
 
 source "drivers/md/Kconfig"
--- a/drivers/scsi/Kconfig      2007-07-09 06:38:37.000000000 +0300
+++ b/drivers/scsi/Kconfig      2007-08-01 06:46:42.000000000 +0300
@@ -7,6 +7,8 @@ config RAID_ATTRS
        ---help---
          Provides RAID
 
+source "drivers/ata/Kconfig"
+
 config SCSI
        tristate "SCSI device support"
        depends on BLOCK



Thanks!

--
Al

