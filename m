Return-Path: <linux-kernel-owner+w=401wt.eu-S1758428AbYE0Srg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428AbYE0Srg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 14:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757138AbYE0SrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 14:47:25 -0400
Received: from mail.vyatta.com ([216.93.170.194]:48731 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757115AbYE0SrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 14:47:24 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.499
Date: Tue, 27 May 2008 11:47:23 -0700
From: Stephen Hemminger <stephen.hemminger@vyatta.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] sky2: don't warn if page allocation fails
Message-ID: <20080527114723.4b2b94f9@speedy>
In-Reply-To: <48354398.9070307@pobox.com>
References: <20080515000412.984337700@vyatta.com>
	<20080515000432.989061538@vyatta.com>
	<48354398.9070307@pobox.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008 05:57:44 -0400
Jeff Garzik <jgarzik@pobox.com> wrote:

> >  
> >  	for (i = 0; i < sky2->rx_nfrags; i++) {
> > -		struct page *page = alloc_page(GFP_ATOMIC);
> > +		struct page *page = alloc_page(GFP_ATOMIC | __GFP_NOWARN);
> >  
> >  		if (!page)
> >  			goto free_partial;
> 
> 
> IMO it's inappropriate to add these warnings to net drivers that 
> properly check all return values.
> 
> This approach is too maintenance intensive, and winds up fixing the same 
> problem over and over again -- a hint that the fix is in the wrong place.
> 
> 	Jeff
> 
> 

So the __GFP_NOWARN should go away and get replaced by GFP_WARN?
