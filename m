Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbXIIELp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbXIIELp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 00:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750926AbXIIELh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 00:11:37 -0400
Received: from [212.12.190.30] ([212.12.190.30]:32801 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750703AbXIIELh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 00:11:37 -0400
From: Al Boldi <a1426z@gawab.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: sata & scsi suggestion for make menuconfig
Date: Sun, 9 Sep 2007 07:11:44 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200709080652.02614.a1426z@gawab.com> <20070908144758.37ab3c76@the-village.bc.nu> <200709081703.31280.a1426z@gawab.com>
In-Reply-To: <200709081703.31280.a1426z@gawab.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200709090711.44048.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> Alan Cox wrote:
> > > I once sent a patch to make libata a submenu of scsi.
> >
> > Which is wrong
> >
> > Nakked-by: Alan Cox <alan@redhat.com>
> >
> > The general comments about moving this stuff around and making it
> > clearer what sd/sr etc are nowdays are good but hiding libata under SCSI
> > will cause even more confusion than it cures
>
> That's easy to fix:  just change the SCSI heading to include a libata
> hint.
>
> Something like this:
>
> [PATCH] libata Kconfig: Allow libata to be selected from within the SCSI
> submenu
>
> Move libata Kconfig sourcing from the drivers Kconfig into the SCSI
> Kconfig, and change the SCSI menu heading to indicate libata submenu
> inclusion.
>
> This allows the user to quickly select additional disk/tape/cdrom support
> from within the same menu.
>
> Signed-off-by: Al Boldi <a1426z@gawab.com>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> ---
> --- a/drivers/Kconfig   2007-05-02 17:25:30.000000000 +0300
> +++ b/drivers/Kconfig   2007-08-01 06:33:13.000000000 +0300
> @@ -22,8 +22,6 @@ source "drivers/ide/Kconfig"
>
>  source "drivers/scsi/Kconfig"
>
> -source "drivers/ata/Kconfig"
> -
>  source "drivers/cdrom/Kconfig"
>
>  source "drivers/md/Kconfig"
> --- a/drivers/scsi/Kconfig      2007-07-09 06:38:37.000000000 +0300
> +++ b/drivers/scsi/Kconfig      2007-08-01 06:46:42.000000000 +0300
> @@ -7,6 +7,8 @@ config RAID_ATTRS
>         ---help---
>           Provides RAID
>
> +source "drivers/ata/Kconfig"
> +
>  config SCSI
> -       tristate "SCSI device support"
> +       tristate "SCSI and Libata device support"
>         depends on BLOCK

Actually, this should have read:

--- a/drivers/scsi/Kconfig	2007-07-09 06:38:37.000000000 +0300
+++ a/drivers/scsi/Kconfig	2007-09-09 06:48:11.000000000 +0300
@@ -1,4 +1,4 @@
-menu "SCSI device support"
+menu "SCSI and Libata (SATA/PATA/new IDE) device support"
 
 config RAID_ATTRS
        tristate "RAID Transport Class"
@@ -7,6 +7,8 @@ config RAID_ATTRS
        ---help---
          Provides RAID
 
+source "drivers/ata/Kconfig"
+
 config SCSI
        tristate "SCSI device support"
        depends on BLOCK


I would think that with this minimal change it would make it crystal clear, 
to anybody who can read, where to enable libata support, and at the same 
time not to forget/overlook sd/sr selection.


Thanks!

--
Al

