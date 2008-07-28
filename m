Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbYG1DSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbYG1DSk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 23:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbYG1DS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 23:18:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:50793 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbYG1DS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 23:18:28 -0400
Subject: Re: [PATCH] typhoon: use request_firmware
From: Jaswinder Singh <jaswinder@infradead.org>
To: David Dillow <dave@thedillows.org>
Cc: LKML <linux-kernel@vger.kernel.org>, becker@scyld.com,
       davidpmclean@yahoo.com, Jeff Garzik <jeff@garzik.org>,
       netdev <netdev@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1217209400.22789.47.camel@obelisk.thedillows.org>
References: <1217170232.3537.6.camel@jaswinder.satnam>
	 <1217209400.22789.47.camel@obelisk.thedillows.org>
Content-Type: text/plain; charset=utf8
Date: Mon, 28 Jul 2008 08:46:49 +0530
Message-Id: <1217215009.2970.7.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dave,

On Sun, 2008-07-27 at 21:43 -0400, David Dillow wrote:

> >  MODULE_LICENSE("GPL");
> > +MODULE_LICENSE("3com/typhoon.bin");
> 
> Uhm, MODULE_FIRMWARE()?
> 

Sorry, Fixed. Thanks.

> > @@ -1368,8 +1371,14 @@ typhoon_download_firmware(struct typhoon *tp)
> >  	int i;
> >  	int err;
> >  
> > +	err = request_firmware(&fw, fw_name, &tp->pdev->dev);
> > +	if (err) {
> > +		printk(KERN_ERR "%s: Failed to load firmware \"%s\"\n",
> > +		       tp->name, fw_name);
> > +		return err;
> > +	}
> >  	err = -EINVAL;
> > -	fHdr = (struct typhoon_file_header *) typhoon_firmware_image;
> > +	fHdr = (struct typhoon_file_header *) fw->data;
> >  	image_data = (u8 *) fHdr;
> >  
> >  	if(memcmp(fHdr->tag, "TYPHOON", 8)) {
> > @@ -1494,6 +1503,7 @@ err_out_irq:
> >  	pci_free_consistent(pdev, PAGE_SIZE, dpage, dpage_dma);
> >  
> >  err_out:
> > +	release_firmware(fw);
> >  	return err;
> >  }
> 
> It is not quite this simple. By not loading the firmware on device
> probe, you have opened the door to a broken resume, and the driver will
> now try to sleep in an atomic context, when typhoon_tx_timeout() is
> called at the very least.
> 

I just added the request_firmware support and
replaced ﻿typhoon_firmware_image with ﻿fw->data.
I do not think this will make any difference in rest of driver.

If you like to change the driver then it should be in another patch.

David Woodhouse, any comments.

> I've said that I was thinking about doing the conversion myself, and I
> think the firmware loader makes some sense for new drivers. But the more
> I think about converting old -- fairly static -- drivers such as
> typhoon, I wonder "what's the point?" We don't save memory, we add code,
> and we add failure points that weren't there before. Where's the upside?
> 

﻿David Woodhouse, any comments.

Thank you,

Jaswinder Singh.

