Return-Path: <linux-kernel-owner+w=401wt.eu-S1751786AbZL1KJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbZL1KJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:09:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbZL1KJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:09:07 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40483 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbZL1KJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:09:03 -0500
Message-ID: <7bf10ff685a06b28084a61dad0740015.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <1261990533.7135.34.camel@laptop>
References: <20091225105140.263180e8.kamezawa.hiroyu@jp.fujitsu.com>
    <1261915391.15854.31.camel@laptop>
    <20091228093606.9f2e666c.kamezawa.hiroyu@jp.fujitsu.com>
    <1261990533.7135.34.camel@laptop>
Date: Mon, 28 Dec 2009 19:08:58 +0900 (JST)
Subject: Re: [RFC PATCH] asynchronous page fault.
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2009-12-28 at 09:36 +0900, KAMEZAWA Hiroyuki wrote:
>> Hmm ? for single-thread apps ? This patch's purpose is not for lockless
>> lookup, it's just a part of work. My purpose is avoiding false-sharing.
>
> False sharing in the sense of the mmap_sem cacheline containing other
> variables?  How could that ever be a problem for a single threaded
> application?
>
No problem at all. I just couldn't catch what you mean.


> For multi-threaded apps the contention on that cacheline is the largest
> issue, and moving it to a vma cacheline doesn't seem like a big
> improvement.
>
I feel mmap_sem's cacheline ping-pong is more terrible than
simple atomic_inc().
__down_read() does
  write (spinlock)
  write (->sem_activity)
  write (unlock)


> You want something much finer grained than vmas, there's lots of apps
> working on a single (or very few) vma(s). Leaving you with pretty much
> the same cacheline contention. Only now its a different cacheline.
>
Ya, maybe. I hope I can find some magical one.
Using per-cpu counter here as Christoph did may be an idea...

Thanks,
-Kame



