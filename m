Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030AbXIHODy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbXIHODy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 10:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbXIHODi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 10:03:38 -0400
Received: from [212.12.190.216] ([212.12.190.216]:32982 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752719AbXIHODh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 10:03:37 -0400
From: Al Boldi <a1426z@gawab.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: sata & scsi suggestion for make menuconfig
Date: Sat, 8 Sep 2007 17:03:31 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200709080652.02614.a1426z@gawab.com> <20070908144758.37ab3c76@the-village.bc.nu>
In-Reply-To: <20070908144758.37ab3c76@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709081703.31280.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> > I once sent a patch to make libata a submenu of scsi.
>
> Which is wrong
>
> Nakked-by: Alan Cox <alan@redhat.com>
>
> The general comments about moving this stuff around and making it clearer
> what sd/sr etc are nowdays are good but hiding libata under SCSI will
> cause even more confusion than it cures

That's easy to fix:  just change the SCSI heading to include a libata hint.

Something like this:

[PATCH] libata Kconfig: Allow libata to be selected from within the SCSI submenu

Move libata Kconfig sourcing from the drivers Kconfig into the SCSI Kconfig,
and change the SCSI menu heading to indicate libata submenu inclusion.

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
-       tristate "SCSI device support"
+       tristate "SCSI and Libata device support"
        depends on BLOCK



Thanks!

--
Al
