Return-Path: <linux-kernel-owner+w=401wt.eu-S1763949AbZLQCJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763949AbZLQCJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 21:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932823AbZLQCJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 21:09:29 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:58745 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763939AbZLQCJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 21:09:21 -0500
Subject: Re: [RFC][Patch] IBM Real-Time "SMI Free" mode drive -v2
From: Keith Mannthey <kmannth@us.ibm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: lkml <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>
In-Reply-To: <20091216000258.4c294d90@lxorguk.ukuu.org.uk>
References: <1260907788.6521.10.camel@keith-laptop>
	 <20091216000258.4c294d90@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Wed, 16 Dec 2009 18:09:14 -0800
Message-Id: <1261015754.6521.99.camel@keith-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-16 at 00:02 +0000, Alan Cox wrote:
> > --- linux-2.6.32/drivers/misc/ibmrtl/ibm_rtl.c	1969-12-31 16:00:00.000000000 -0800
> > +++ linux-2.6.32-rtl/drivers/misc/ibmrtl/ibm_rtl.c	2009-12-14 16:37:19.000000000 -0800
> 
> Probably belongs in drivers/firmware as its not a misc_* interface user.

Ack. 

> > +	/* Get the address for the Extende Biso Data Area */
> > +	ebda_addr = *(u16 *) phys_to_virt(EDBA_ADDR);
> > +	ebda_addr <<= 4;
> > +	edba_map = ioremap(ebda_addr, 4);
> > +	if (!edba_map)
> > +		return -ENOMEM;
> 
> This is wrong. I wish we had a single proper EBDA handling function
> because this keeps coming up.
>
> The rules for the EBDA on PC class hardware as that the EBDA address
> provides a real segment offset for the EBDA *if one is present*. Lots of
> machines including quite a few suprisingly modern boxes (eg AMD76x
> systems without a PS/2 mouse plugged in) don't have an EBDA so you need
> to check if the word you read is zero before doing an ioremap.

Ok so if I can read a word at 0x40E that means an EDBA table is present?

> > +	for (table = (u32 *) edba_map ; \
> > +			table < (u32 *) edba_map + ebda_size/4; table++)
> 
> You need to check the table is valid and has a correct signature. Not
> doing so is completely unsafe.

What does a valid signature on an EDBA look like, I really do not have
much info on the table. 

How do I check the signature? I don't really have lot of into about the
EDBA region any info is helpful. 

Thanks,
  Keith Mannthey
  LTC Real-Time 

