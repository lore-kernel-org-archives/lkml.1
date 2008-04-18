Return-Path: <linux-kernel-owner+w=401wt.eu-S1760951AbYDRTZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760951AbYDRTZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 15:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760809AbYDRTZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 15:25:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56977 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760801AbYDRTZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 15:25:03 -0400
Date: Fri, 18 Apr 2008 15:25:00 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Pekka Paalanen <pq@iki.fi>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH sched-devel] ftrace: trace_entries to change trace buffer
 size
In-Reply-To: <20080418121431.7f1c05f1.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0804181521200.14933@gandalf.stny.rr.com>
References: <20080411163923.439680284@goodmis.org> <20080411164037.219665668@goodmis.org>
 <20080411214328.25c06a5d@daedalus.pq.iki.fi> <Pine.LNX.4.58.0804112021200.4500@gandalf.stny.rr.com>
 <20080413145604.3fb396a2@daedalus.pq.iki.fi> <20080414095645.GC3761@elte.hu>
 <20080414211433.3bfa5649@daedalus.pq.iki.fi> <Pine.LNX.4.58.0804142139240.16591@gandalf.stny.rr.com>
 <20080418032301.0f7bef7d.akpm@linux-foundation.org>
 <Pine.LNX.4.58.0804180822510.5642@gandalf.stny.rr.com>
 <20080418121431.7f1c05f1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 18 Apr 2008, Andrew Morton wrote:
> >
> > Actually, that's just a way of doing spin_lock_init for raw spin locks. I
> > didn't see any other way.
>
> Maybe we need raw_spin_lock_init().  And DEFINE_RAW_SPINLOCK()?
>
> Although it isn't a great idea to be encouraging the use of raw
> spinlocks.
>

I was thinking the same thing. Raw spin_locks should not be used, unless
there's a really good reason to use them. Strange things like mcount is
one example, but I cant think of many more. I'd be hesitant to add such an
API, which might lead to other users of raw_spin_locks when they really
shouldn't.

Not to mention that we also have raw_spinlock_t in -rt that has a little
different meaning.

-- Steve

