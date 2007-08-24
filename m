Return-Path: <linux-kernel-owner+w=401wt.eu-S1759525AbXHXKxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbXHXKxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 06:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbXHXKx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 06:53:28 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:60665 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357AbXHXKx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 06:53:28 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 24 Aug 2007 06:43:33 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Denys Vlasenko <vda.linux@googlemail.com>
cc: Jesper Juhl <jesper.juhl@gmail.com>, linux-mtd@lists.infradead.org,
       David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/30] mtd: Don't cast kmalloc() return value in
 drivers/mtd/maps/pmcmsp-flash.c
In-Reply-To: <200708241141.06358.vda.linux@googlemail.com>
Message-ID: <Pine.LNX.4.64.0708240642500.18301@localhost.localdomain>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
 <5ebfb93eca0dd43cf17876e643079cbcfeb3111c.1187912217.git.jesper.juhl@gmail.com>
 <200708241141.06358.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.367, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	SARE_SUB_6CONS_WORD 0.36, TW_FC 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007, Denys Vlasenko wrote:

> On Friday 24 August 2007 00:52, Jesper Juhl wrote:
> > kmalloc() returns a void pointer.
> > No need to cast it.
>
> > -	msp_flash = (struct mtd_info **)kmalloc(
> > -			fcnt * sizeof(struct map_info *), GFP_KERNEL);
> > -	msp_parts = (struct mtd_partition **)kmalloc(
> > -			fcnt * sizeof(struct mtd_partition *), GFP_KERNEL);
> > -	msp_maps = (struct map_info *)kmalloc(
> > -			fcnt * sizeof(struct mtd_info), GFP_KERNEL);
> > +	msp_flash = kmalloc(fcnt * sizeof(struct map_info *), GFP_KERNEL);
> > +	msp_parts = kmalloc(fcnt * sizeof(struct mtd_partition *), GFP_KERNEL);
> > +	msp_maps = kmalloc(fcnt * sizeof(struct mtd_info), GFP_KERNEL);
> >  	memset(msp_maps, 0, fcnt * sizeof(struct mtd_info));
>
> This one wants kzalloc.
>
> > -		msp_parts[i] = (struct mtd_partition *)kmalloc(
> > -			pcnt * sizeof(struct mtd_partition), GFP_KERNEL);
> > +		msp_parts[i] = kmalloc(pcnt * sizeof(struct mtd_partition),
> > +			GFP_KERNEL);
> >  		memset(msp_parts[i], 0, pcnt * sizeof(struct mtd_partition));
> >
> >  		/* now initialize the devices proper */
>
> Same

actually, i would think kcalloc would be more appropriate here, no?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
