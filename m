Return-Path: <linux-kernel-owner+w=401wt.eu-S932476AbXGaRyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476AbXGaRyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765280AbXGaRxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:53:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49644 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762472AbXGaRxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:53:54 -0400
Date: Tue, 31 Jul 2007 23:36:10 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Greg KH <gregkh@suse.de>
cc: Andreas Schwab <schwab@suse.de>, WANG Cong <xiyou.wangcong@gmail.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       jack@hawkeye.stone.uk.eu.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [Patch 09/16] Remove unnecessary kmalloc casts in the pci
 subsystem.
In-Reply-To: <20070731174755.GA8592@suse.de>
Message-ID: <alpine.LFD.0.999.0707312334260.28746@enigma.security.iitk.ac.in>
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org>
 <20070731125443.880871000@hawkeye.stone.uk.eu.org> <200707311553.29090.borntraeger@de.ibm.com>
 <alpine.LFD.0.999.0707311956170.26032@enigma.security.iitk.ac.in>
 <20070731144619.GA8183@localhost.localdomain> <20070731161051.GA7490@suse.de>
 <jeir80y27m.fsf@sykes.suse.de> <20070731174755.GA8592@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 31 Jul 2007, Greg KH wrote:

> On Tue, Jul 31, 2007 at 06:20:29PM +0200, Andreas Schwab wrote:
> > Greg KH <gregkh@suse.de> writes:
> > 
> > > On Tue, Jul 31, 2007 at 10:46:19PM +0800, WANG Cong wrote:
> > >> However, I think using resource_size_t is a bit better than unsigned long,
> > >> so that we don't need to check the defination of it.
> > >> 
> > >> - res->start = (unsigned long)kmalloc(*size, GFP_KERNEL);
> > >> + res->start = (resource_size_t)kmalloc(*size, GFP_KERNEL);
> > >> 
> > >> Is this change OK?
> > >
> > > Yes, that is the proper cast to have here.
> > 
> > It will generate a warning when resoure_size_t is 64bit on a 32bit arch.
> 
> How?

warning: cast from pointer to integer of different size

(it's from smaller to larger size, so not really truncation,
but gcc does barf)

> And if so, what should the proper cast be?

sizeof(unsigned long) == sizeof(void *) should always be true.


Satyam
