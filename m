Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbZLJXqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbZLJXqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 18:46:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756690AbZLJXqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 18:46:09 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38928 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092AbZLJXqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 18:46:08 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 11 Dec 2009 08:42:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       minchan.kim@gmail.com, mingo@elte.hu
Subject: Re: [RFC mm][PATCH 1/5] mm counter cleanup
Message-Id: <20091211084255.ec7d3f49.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.0912101126480.5481@router.home>
References: <20091210163115.463d96a3.kamezawa.hiroyu@jp.fujitsu.com>
	<20091210163326.28bb7eb8.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0912101126480.5481@router.home>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Dec 2009 11:30:46 -0600 (CST)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Thu, 10 Dec 2009, KAMEZAWA Hiroyuki wrote:
> 
> > This patch modifies it to
> >   - Define them in mm.h as inline functions
> >   - Use array instead of macro's name creation. For making easier to add
> >     new coutners.
> 
> Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
> 
> > @@ -454,8 +456,8 @@ static struct mm_struct * mm_init(struct
> >  		(current->mm->flags & MMF_INIT_MASK) : default_dump_filter;
> >  	mm->core_state = NULL;
> >  	mm->nr_ptes = 0;
> > -	set_mm_counter(mm, file_rss, 0);
> > -	set_mm_counter(mm, anon_rss, 0);
> > +	for (i = 0; i < NR_MM_COUNTERS; i++)
> > +		set_mm_counter(mm, i, 0);
> 
> 
> memset? Or add a clear_mm_counter function? This also occurred earlier in
> init_rss_vec().
> 
Ok, I'll try some cleaner codes.

Thanks,
-Kame

