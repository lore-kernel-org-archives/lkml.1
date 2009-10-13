Return-Path: <linux-kernel-owner+w=401wt.eu-S1758531AbZJMAEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531AbZJMAEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 20:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757316AbZJMAED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 20:04:03 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50648 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027AbZJMAEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 20:04:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [resend][PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
Cc: kosaki.motohiro@jp.fujitsu.com, Bryan Donlan <bdonlan@gmail.com>,
       linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>,
       linux-api@vger.kernel.org, Timo Sirainen <tss@iki.fi>
In-Reply-To: <20091012122246.a941013b.akpm@linux-foundation.org>
References: <20091013022335.C741.A69D9226@jp.fujitsu.com> <20091012122246.a941013b.akpm@linux-foundation.org>
Message-Id: <20091013083744.C747.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 13 Oct 2009 09:03:22 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 13 Oct 2009 04:03:45 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > > Start simple.  What's wrong with mutex_lock() on the reader and writer
> > > sides?  rwsems might be OK too.
> > > 
> > > In both cases we should think about whether persistent readers can
> > > block the writer excessively though.
> > 
> > I thought your mention seems reasonable. then I mesured various locking
> > performance.
> > 
> > 		no-contention	read-read contetion	read-write contention
> > w/o patch	4627 ms		 7575 ms		 N/A
> > mutex		5717 ms		33872 ms (!)		14793 ms
> > rw-semaphoe	6846 ms		10734 ms		36156 ms (!)
> > seqlock		4754 ms		 7558 ms		 9373 ms
> > 
> > Umm, seqlock is significantly better than other.
> 
> Sure, but even the worst case there is 1,000,000 operations in 34
> seconds (yes?). 33 microseconds for a /proc read while under a specific
> local DoS attack is OK!
> 
> If so then all implementations are acceptable and we should choose the
> simplest, most-obviously-correct one.

Hm, ok!

I had guessed you don't accept this slowness. but my guess was wrong.
I have no objection to use rw-semaphoe if you accept it. 


