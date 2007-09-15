Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbXIOOnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbXIOOnk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 10:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbXIOOnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 10:43:32 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:56208 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751027AbXIOOna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 10:43:30 -0400
Date: Sat, 15 Sep 2007 16:43:41 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       James Bottomley <james.bottomley@steeleye.com>,
       linux-scsi@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       Andi Kleen <andi@firstfloor.org>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] SCSI: split Kconfig menu into two
Message-ID: <20070915144341.GT3563@stusta.de>
References: <tkrat.913e8b183cdf7888@s5r6.in-berlin.de> <20070914190033.GA4003@uranus.ravnborg.org> <20070914190609.GN3563@stusta.de> <tkrat.552dbee831c88bbe@s5r6.in-berlin.de> <20070915114055.GP3563@stusta.de> <46EBCEF1.4030702@s5r6.in-berlin.de> <20070915125055.GQ3563@stusta.de> <46EBDC06.3030202@s5r6.in-berlin.de> <20070915135314.GS3563@stusta.de> <46EBE821.2080300@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46EBE821.2080300@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 15, 2007 at 04:11:45PM +0200, Stefan Richter wrote:
> Adrian Bunk wrote:
> > On Sat, Sep 15, 2007 at 03:20:06PM +0200, Stefan Richter wrote:
> >> It still doesn't entirely clarify whether users need sd, sr, st, and
> >> whether thy need sd for the disk with root filesystem.
> > 
> > If you want to do it in a really perfect way, help texts aren't the 
> > solution. You'll have to make the options like CONFIG_BLK_DEV_SR no 
> > longer be user visible and select'ed through dummy options like e.g.:
> ...
> > 	tristate "USB Mass Storage hard disk support"
> > 	depends on USB_STORAGE
> > 	select BLK_DEV_SD
> ...
> >         tristate "USB Mass Storage CD/DVD support"
> >         depends on USB_STORAGE
> > 	select BLK_DEV_SR
> ...
> 
> Perfect is in the eye of the beholder.  You would consequently have to
> add such options into all menus which contain scsi low-level providers.

Kconfig is a user interface, so perfect is what is best for the
kconfig users.

> Also, one more question on whether CONFIG_SCSI ought to be 'select'ed:
> Where do scsi-core options like CONFIG_SCSI_CONSTANTS go?

The first question is whether it's for actual SCSI hardware [1] or for 
the block layer functionality which the SCSI subsystem has become.
The mixture of these two is the root of much user confusion.

With the help text "The error messages regarding your SCSI hardware will 
be easier to understand if you say Y here" a user wouldn't have expected 
to see you using it in a firewire driver. But unless I miss anything, 
the setting of SCSI_SCAN_ASYNC does only affect "real" SCSI hardware.

If you check each option and place it either in the generic storage menu 
or the SCSI lowlevel menu this would fix much possible user confusion.

But these are relatively unimportant options compared to e.g.
USB_STORAGE=y, BLK_DEV_SD=n, which is a misconfiguration many
users run into, so having one menu somewhere with these advanced 
options should be enough.

> Stefan Richter

cu
Adrian

[1] SCSI as in "sold as SCSI"

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

