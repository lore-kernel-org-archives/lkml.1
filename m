Return-Path: <linux-kernel-owner+w=401wt.eu-S1753298AbZBJIyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbZBJIyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 03:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbZBJIyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 03:54:15 -0500
Received: from ozlabs.org ([203.10.76.45]:56562 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbZBJIyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 03:54:15 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Date: Tue, 10 Feb 2009 19:24:07 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: travis@sgi.com, mingo@redhat.com, davej@redhat.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090116191108.135927000@polaris-admin.engr.sgi.com> <200902042111.35543.rusty@rustcorp.com.au> <20090204073636.30f15339.akpm@linux-foundation.org>
In-Reply-To: <20090204073636.30f15339.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200902101924.08656.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 February 2009 02:06:36 Andrew Morton wrote:
> On Wed, 4 Feb 2009 21:11:35 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > On Wednesday 04 February 2009 13:31:11 Andrew Morton wrote:
> > > On Wed, 4 Feb 2009 13:14:31 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > > I think you're right though: smp_call_function_single (or neat wrappers)
> > > > where possible, work_on_cpu which can fail for the others, and we'll just
> > > > have to plumb in the error returns.
> > > 
> > > I bet a lot of those can use plain old schedule_work_on().
> > 
> > Which is where work_on_cpu started: a little wrapper around schedule_work_on.
> > 
> > We're going in circles, no?
> 
> No, we've made some progress.  We have a better understanding of what
> the restrictions, shortcomings and traps are in this stuff.  We've
> learned (surprise!) that a one-size-fits-all big hammer wasn't such a
> great idea.
> 
> Proposed schedule_work_on() rule: either the flush_work() caller or the
> callback should not hold any explicit or implicit sleeping locks.

But as you found out looking through these, it's really hard to tell.  I can
guess, but that's a little fraught...

How about we make work_on_cpu spawn a temp thread; if you care, use
something cleverer?  Spawning a thread just isn't that slow.

Meanwhile, I'll prepare patches to convert all the non-controversial cases
(ie. smp_call_function-style ones).

Cheers,
Rusty.
