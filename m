Return-Path: <linux-kernel-owner+w=401wt.eu-S1755140AbZESEob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbZESEob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 00:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbZESEoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 00:44:22 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48488 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbZESEoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 00:44:21 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 2/3] vmscan: make mapped executable pages the first class citizen
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
In-Reply-To: <20090519133422.4ECC.A69D9226@jp.fujitsu.com>
References: <20090519032759.GA7608@localhost> <20090519133422.4ECC.A69D9226@jp.fujitsu.com>
Message-Id: <20090519134253.4ECF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 19 May 2009 13:44:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > begin:       2479             2344             9659              210                0           579643
> > end:          284           232010           234142              260           772776         20917184
> > restore:      379           232159           234371              301           774888         20967849
> > 
> > The numbers show that
> > 
> > - The startup pgmajfault of 2.6.30-rc4-mm is merely 1/3 that of 2.6.29.
> >   I'd attribute that improvement to the mmap readahead improvements :-)
> > 
> > - The pgmajfault increment during the file copy is 633-630=3 vs 260-210=50.
> >   That's a huge improvement - which means with the VM_EXEC protection logic,
> >   active mmap pages is pretty safe even under partially cache hot streaming IO.
> > 
> > - when active:inactive file lru size reaches 1:1, their scan rates is 1:20.8
> >   under 10% cache hot IO. (computed with formula Dpgdeactivate:Dpgfree)
> >   That roughly means the active mmap pages get 20.8 more chances to get
> >   re-referenced to stay in memory.
> > 
> > - The absolute nr_mapped drops considerably to 1/9 during the big IO, and the
> >   dropped pages are mostly inactive ones. The patch has almost no impact in
> >   this aspect, that means it won't unnecessarily increase memory pressure.
> >   (In contrast, your 20% mmap protection ratio will keep them all, and
> >   therefore eliminate the extra 41 major faults to restore working set
> >   of zsh etc.)
> 
> I'm surprised this.
> Why your patch don't protect mapped page from streaming io?

I guess you use initlevel=5 and use only terminal, right?
if so, dropping some graphics component makes sense.


> 
> I strongly hope reproduce myself, please teach me reproduce way.




