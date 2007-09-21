Return-Path: <linux-kernel-owner+w=401wt.eu-S1759033AbXIUSnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759033AbXIUSnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 14:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761731AbXIUSnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 14:43:17 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47949 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761691AbXIUSnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 14:43:15 -0400
Date: Sat, 22 Sep 2007 03:42:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: clameter@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, nickpiggin@yahoo.com.au,
       ricknu-0@student.ltu.se, magnus.damm@gmail.com
Subject: Re: [RFC][PATCH] page->mapping clarification [1/3] base functions
Message-Id: <20070922034234.bdb947e4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0709211716220.20783@blonde.wat.veritas.com>
References: <20070919164308.281f9960.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0709201120510.8801@schroedinger.engr.sgi.com>
	<20070921095054.6386bae1.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0709211716220.20783@blonde.wat.veritas.com>
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007 18:02:47 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:
> > 3. I want to *try* page->mapping overriding... store  memory resource controller's   
> >    information in page->mapping. By this, memory controller doesn't enlarge sizeof
> >    struct page. (works well in my small test.)
> >    Before doing that, I have to hide page->mapping from direct access.
> 
> My own vote (nothing more) would be for you to set this aside until
> some future time when there aren't a dozen developers all trampling
> over each other in this area.
> 
> They're invasive little changes affecting all filesystems, whereas what
> we've done so far with page->mapping hasn't affected filesystems at all.
> 
I found that each FS doesn't touch page->mapping so much as I expected.
(except for ReiserFS)
But ok, I admit changing this will confuse people.

> 3: well, saving memory is good, but I think it could wait until some
> other time, particularly since the memory controller isn't in yet.
> 
Yes, if extra field in page struct is not hazard to push memory controller,
I don't have much motivation. 
Because extra 8 bytes makes page struct to be 64 bytes(in 64bit), extra 8 bytes
is the last space, I think.

> If we were to attack page->mapping to save memory from struct page,
> then we should consider Magnus Damm's idea too: he suggested it could
> be replaced by a pointer to the radixtree slot (something else needed
> in the anon case), from which "index" could be deduced via alignment
> instead of keeping it in struct page (details to be filled in ...)
> 
There is a bit difference. My purpose is "avoid making struct page larger",
not "making struct page smaller". 

> Or should I now leave PG_swapcache as is,
> given your designs on page->mapping?
> 
 will conflict with my idea ?
==
http://marc.info/?l=linux-mm&m=118956492926821&w=2
==

Anyway, I'm not in hurry about this patch-set. I'll see what memory controller
will go. Other people seems to have an idea to implement 
pfn <-> container_info_per_page function.
(But this kind of function is not welcomed always.)

Thank you for comments.

> p.s. Sorry to niggle, but next time, please say [PATCH 1/3] etc.
> rather than [PATCH] Long Description [1/3], so it's easier to
> sort the mail subjects by eye in limited columns - thanks.
> 
sorry, I'll consider well next time.

Thanks,
-Kame
