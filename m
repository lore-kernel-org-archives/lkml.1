Return-Path: <linux-kernel-owner+w=401wt.eu-S1755028AbYFVPHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbYFVPHw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 11:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbYFVPHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 11:07:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:37044 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbYFVPHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 11:07:41 -0400
Subject: Re: [BUG] Lockless patches cause hardlock under heavy IO
From: Peter Zijlstra <peterz@infradead.org>
To: Ryan Hope <rmh3093@gmail.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-mm@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <48f7fe350806220737q7cc48d81g29b0fc85fc59d390@mail.gmail.com>
References: <48f7fe350806181415l4eba61b3i1d206de03147575e@mail.gmail.com>
	 <1213863122.16944.257.camel@twins>
	 <200806191819.31968.nickpiggin@yahoo.com.au>
	 <48f7fe350806220737q7cc48d81g29b0fc85fc59d390@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 22 Jun 2008 17:07:23 +0200
Message-Id: <1214147244.3223.307.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-06-22 at 10:37 -0400, Ryan Hope wrote:
> Well I couldn't stop playing with this... I am pretty sure the cause
> of the hardlocks is in the second half of the patches (the speculative
> page ref patches). I reversed all of those patches so that just the
> GUP patchs were included and no more hardlocks... then I applied the
> concurrent page cache patches from the -rt branch include 1 OLD
> speculative page ref patch and this caused hardlocks for peopel again.
> However enabling heap randomization fixed the hardlocks for one of the
> users and the disabling swap fixed the issue of the other user. I hope
> this helps.

What are people doing to make it hang?

> On Thu, Jun 19, 2008 at 4:19 AM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > On Thursday 19 June 2008 18:12, Peter Zijlstra wrote:
> >> On Wed, 2008-06-18 at 17:15 -0400, Ryan Hope wrote:
> >> > I applied the following patches from 2.6-26-rc5-mm3 to 2.6.26-rc6 and
> >> > they caused a hardlock under heavy IO:
> >>
> >> What kind of machine, how much memory, how many spindles, what
> >> filesystem and what is heavy load?
> >>
> >> Furthermore, try the NMI watchdog with serial/net-console to capture its
> >> output.
> >
> >
> > Good suggestions. A trace would be really helpful.
> >
> > As Arjan suggested, debug options especially CONFIG_DEBUG_VM would be
> > a good idea to turn on if you haven't already.
> >
> > BTW. what was the reason for applying those patches? Did you hit the
> > problem with -mm also, and hope to narrow it down?
> >
> >
> >> > x86-implement-pte_special.patch
> >> > mm-introduce-get_user_pages_fast.patch
> >> > mm-introduce-get_user_pages_fast-fix.patch
> >> > mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
> >> > x86-lockless-get_user_pages_fast.patch
> >> > x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
> >> > x86-lockless-get_user_pages_fast-fix.patch
> >> > x86-lockless-get_user_pages_fast-fix-2.patch
> >> > x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
> >> > x86-lockless-get_user_pages_fast-fix-warning.patch
> >> > dio-use-get_user_pages_fast.patch
> >> > splice-use-get_user_pages_fast.patch
> >> > x86-support-1gb-hugepages-with-get_user_pages_lockless.patch
> >> > #
> >> > mm-readahead-scan-lockless.patch
> >> > radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
> >> > #mm-speculative-page-references.patch: clameter saw bustage
> >> > mm-speculative-page-references.patch
> >> > mm-speculative-page-references-fix.patch
> >> > mm-speculative-page-references-fix-fix.patch
> >> > mm-speculative-page-references-hugh-fix3.patch
> >> > mm-lockless-pagecache.patch
> >> > mm-spinlock-tree_lock.patch
> >> > powerpc-implement-pte_special.patch
> >> >
> >> > I am on an x86_64. I dont know what other info you need...
> >
> > Can you isolate it to one of the two groups of patches? I suspect it
> > might be the latter so you might try that first -- this version of
> > speculative page references is very nice in theory but it is a little
> > more complex to implement the slowpaths so it could be an error there.
> >

