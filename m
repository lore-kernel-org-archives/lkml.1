Return-Path: <linux-kernel-owner+w=401wt.eu-S1764170AbXGaPxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764170AbXGaPxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 11:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbXGaPxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 11:53:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58575 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275AbXGaPxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 11:53:14 -0400
Date: Tue, 31 Jul 2007 21:35:30 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: WANG Cong <xiyou.wangcong@gmail.com>
cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       jack@hawkeye.stone.uk.eu.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [Patch 09/16] Remove unnecessary kmalloc casts in the pci
 subsystem.
In-Reply-To: <20070731144619.GA8183@localhost.localdomain>
Message-ID: <alpine.LFD.0.999.0707312129390.28746@enigma.security.iitk.ac.in>
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org>
 <20070731125443.880871000@hawkeye.stone.uk.eu.org> <200707311553.29090.borntraeger@de.ibm.com>
 <alpine.LFD.0.999.0707311956170.26032@enigma.security.iitk.ac.in>
 <20070731144619.GA8183@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 31 Jul 2007, WANG Cong wrote:

> On Tue, Jul 31, 2007 at 08:00:12PM +0530, Satyam Sharma wrote:
> > [...]
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

Yes, that would probably be clearer.
