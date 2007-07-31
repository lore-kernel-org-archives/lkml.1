Return-Path: <linux-kernel-owner+w=401wt.eu-S1762936AbXGaQLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762936AbXGaQLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbXGaQLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:11:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:51067 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbXGaQLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:11:45 -0400
Date: Tue, 31 Jul 2007 09:10:51 -0700
From: Greg KH <gregkh@suse.de>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Satyam Sharma <satyam@infradead.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       jack@hawkeye.stone.uk.eu.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [Patch 09/16] Remove unnecessary kmalloc casts in the pci
	subsystem.
Message-ID: <20070731161051.GA7490@suse.de>
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org> <20070731125443.880871000@hawkeye.stone.uk.eu.org> <200707311553.29090.borntraeger@de.ibm.com> <alpine.LFD.0.999.0707311956170.26032@enigma.security.iitk.ac.in> <20070731144619.GA8183@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731144619.GA8183@localhost.localdomain>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 10:46:19PM +0800, WANG Cong wrote:
> On Tue, Jul 31, 2007 at 08:00:12PM +0530, Satyam Sharma wrote:
> >
> >
> >On Tue, 31 Jul 2007, Christian Borntraeger wrote:
> >
> >> Am Dienstag, 31. Juli 2007 schrieb jack@hawkeye.stone.uk.eu.org:
> >> > --- a/drivers/pci/rom.c
> >> > +++ b/drivers/pci/rom.c
> >> > @@ -185,7 +185,7 @@ void __iomem *pci_map_rom_copy(struct pc
> >> >  			  IORESOURCE_ROM_BIOS_COPY))
> >> >  		return rom;
> >> > 
> >> > -	res->start = (unsigned long)kmalloc(*size, GFP_KERNEL);
> >> > +	res->start = kmalloc(*size, GFP_KERNEL);
> >> 
> >> This looks wrong.
> >
> >Yup, a warning at the very least.
> >
> >> void * doesnt need a cast to a pointer, but res->start is an 
> >> integer u32 type,
> >
> >It better not be, else we have a bug already anyway. Pointers are 64-bit
> >on 64-bit archs. [ it turns out res->start is resource_size_t which is
> >set properly as per CONFIG_RESOURCES_64BIT which itself is set properly
> >as per CONFIG_64BIT, so everything is healthy and fine :-) ]
> >
> 
> I agree.
> 
> However, I think using resource_size_t is a bit better than unsigned long,
> so that we don't need to check the defination of it.
> 
> - res->start = (unsigned long)kmalloc(*size, GFP_KERNEL);
> + res->start = (resource_size_t)kmalloc(*size, GFP_KERNEL);
> 
> Is this change OK?

Yes, that is the proper cast to have here.

thanks,

greg k-h
