Return-Path: <linux-kernel-owner+w=401wt.eu-S1753964AbYAXHzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbYAXHzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 02:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748AbYAXHzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 02:55:41 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42767 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752722AbYAXHzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 02:55:40 -0500
Date: Wed, 23 Jan 2008 23:55:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: bn@niasdigital.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] fix variable use in AVR32 pte_alloc_one
Message-Id: <20080123235531.9334c13a.akpm@linux-foundation.org>
In-Reply-To: <20080123132010.266eccb8@dhcp-252-066.norway.atmel.com>
References: <47972BAE.70902@niasdigital.com>
	<20080123132010.266eccb8@dhcp-252-066.norway.atmel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 23 Jan 2008 13:20:10 +0100 Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> On Wed, 23 Jan 2008 22:57:34 +1100
> Ben Nizette <bn@niasdigital.com> wrote:
> 
> > 
> > Some parts of this function use 'page', some 'pte'.  As such, an AVR32
> > -mm build fails with an undefined reference to 'page'.
> > 
> > Signed-Off-By: Ben Nizette <bn@niasdigital.com>
> > 
> > ---
> > Index: linux-2.6.24-rc8-mm1/include/asm-avr32/pgalloc.h
> > ===================================================================
> > --- linux-2.6.24-rc8-mm1.orig/include/asm-avr32/pgalloc.h
> > +++ linux-2.6.24-rc8-mm1/include/asm-avr32/pgalloc.h
> > @@ -52,9 +52,9 @@ static inline struct page *pte_alloc_one
> >  	struct page *pte;
> >  
> >  	pte = alloc_page(GFP_KERNEL | __GFP_REPEAT | __GFP_ZERO);
> > -	if (!page)
> > +	if (!pte)
> >  		return NULL;
> > -	pgtable_page_ctor(page);
> > +	pgtable_page_ctor(pte);
> >  	return pte;
> >  }
> 
> Hmm...I can't see anything like this on my current avr32-arch branch,
> but I think I mistakenly pushed out some unfinished code about a week
> ago and rewound it shortly afterwards. If Andrew pulled during that
> window, I guess it must have made it into -mm :-(
> 
> But thanks for testing and for providing a fix. I'll check the code
> that I was working on and apply the patch if it's still broken.
> 

This bustage was added by the -mm-only
config_highpte-vs-sub-page-page-tables.patch

Thanks for the fix.
