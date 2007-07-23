Return-Path: <linux-kernel-owner+w=401wt.eu-S1763645AbXGWVgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763645AbXGWVgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 17:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755058AbXGWVgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 17:36:06 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:36138 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486AbXGWVgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 17:36:05 -0400
Date: Mon, 23 Jul 2007 23:37:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.23-rc1: BUG_ON in kmap_atomic_prot()
Message-ID: <20070723213719.GA9565@uranus.ravnborg.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <20070723183839.GA5874@martell.zuzino.mipt.ru> <20070723190152.GA5755@martell.zuzino.mipt.ru> <20070723132431.42afbae8.akpm@linux-foundation.org> <20070723204045.GD5755@martell.zuzino.mipt.ru> <20070723210153.GA5753@martell.zuzino.mipt.ru> <20070723141137.171e4ac1.akpm@linux-foundation.org> <alpine.LFD.0.999.0707231415511.3607@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707231415511.3607@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> For example, missing from the call graph is
> 
> 	get_page_from_freelist ->
> 	  buffered_rmqueue ->		[ missing - inlined ]
> 	    prep_new_page ->		[ missing - inlined ]
> 	      prep_zero_page ->		[ missing - inlined ]
> 		clear_highpage ->	[ missing - inlined ]
> 		  kmap_atomic ->	[ missing - tailcall ]
> 		    kmap_atomic_prot
> 
> (and I'm also pretty sure gcc 
> is overly aggressive at inlining, and that it causes us pain for 
> debugging, but whatever)

mm/page_alloc.c:static inline void prep_zero_page(struct page *page, int order, gfp_t gfp_flags)
include/linux/highmem.h:static inline void clear_highpage(struct page *page)

So at least two was explicit marked inline.
Now if that made I change i dunno.

	Sam
