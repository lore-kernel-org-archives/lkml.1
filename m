Return-Path: <linux-kernel-owner+w=401wt.eu-S1765823AbXINBEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765823AbXINBEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 21:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756901AbXINBEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 21:04:47 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58966 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729AbXINBEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 21:04:46 -0400
Date: Fri, 14 Sep 2007 10:06:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] add page->mapping handling interface [1/35] interface
 definitions
Message-Id: <20070914100634.bee81fe6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <46E99B48.6050106@student.ltu.se>
References: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
	<20070910184239.e1f705c9.kamezawa.hiroyu@jp.fujitsu.com>
	<46E99B48.6050106@student.ltu.se>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007 22:19:20 +0200
Richard Knutsson <ricknu-0@student.ltu.se> wrote:
> > +static inline int page_is_pagecache(struct page *page)
> >   
> Why return it as an 'int' instead of 'bool'?
> > +{
> > +	if (!page->mapping || (page->mapping & PAGE_MAPPING_ANON))
> > +		return 0;
> > +	return 1;
> > +}

Ah, I missed bool type just because I have no experience to use 'bool' in
Linux kernel. ok, will try in the next version. thank you.

> >   
> Not easier with 'return page->mapping && (page->mapping & 
> PAGE_MAPPING_ANON) == 0;'?
> > +

yours seems better.


> 
> >  static inline int PageAnon(struct page *page)
> >   
> Change to bool? Then "you" can also remove the '!!' from:
> mm/memory.c:483:                rss[!!PageAnon(page)]++;

Hmm, will try unless it makes diff big.

> >  {
> > -	return ((unsigned long)page->mapping & PAGE_MAPPING_ANON) != 0;
> > +	return (page->mapping & PAGE_MAPPING_ANON) != 0;
> > +}
> > +
> >   
> <snip>
> 
> If you don't mind bool(eans) (for some reason), I can/will check out the 
> rest.
> 

Thank you. I'll try 'bool' type. 

Regards,
-Kame

