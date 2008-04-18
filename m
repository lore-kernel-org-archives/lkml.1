Return-Path: <linux-kernel-owner+w=401wt.eu-S932743AbYDRTPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743AbYDRTPz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 15:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932618AbYDRTPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 15:15:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932617AbYDRTPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 15:15:40 -0400
Date: Fri, 18 Apr 2008 12:14:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Pekka Paalanen <pq@iki.fi>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH sched-devel] ftrace: trace_entries to change trace
 buffer size
Message-Id: <20080418121431.7f1c05f1.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.58.0804180822510.5642@gandalf.stny.rr.com>
References: <20080411163923.439680284@goodmis.org>
	<20080411164037.219665668@goodmis.org>
	<20080411214328.25c06a5d@daedalus.pq.iki.fi>
	<Pine.LNX.4.58.0804112021200.4500@gandalf.stny.rr.com>
	<20080413145604.3fb396a2@daedalus.pq.iki.fi>
	<20080414095645.GC3761@elte.hu>
	<20080414211433.3bfa5649@daedalus.pq.iki.fi>
	<Pine.LNX.4.58.0804142139240.16591@gandalf.stny.rr.com>
	<20080418032301.0f7bef7d.akpm@linux-foundation.org>
	<Pine.LNX.4.58.0804180822510.5642@gandalf.stny.rr.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 08:48:09 -0400 (EDT) Steven Rostedt <rostedt@goodmis.org> wrote:

> > > +		data->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
> > > +		max_tr.data[i]->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
> >
> > eww.  This *really* needs explanatory comments.
> >
> 
> Actually, that's just a way of doing spin_lock_init for raw spin locks. I
> didn't see any other way.

Maybe we need raw_spin_lock_init().  And DEFINE_RAW_SPINLOCK()?

Although it isn't a great idea to be encouraging the use of raw 
spinlocks.
