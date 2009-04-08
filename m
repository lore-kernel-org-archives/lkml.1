Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbZDHXpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbZDHXpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 19:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755617AbZDHXpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 19:45:21 -0400
Received: from ozlabs.org ([203.10.76.45]:37930 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755269AbZDHXpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 19:45:20 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: pm-hibernate : possible circular locking dependency detected
Date: Thu, 9 Apr 2009 09:15:17 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.27-11-generic; KDE/4.2.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ming Lei <tom.leiming@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Gautham R Shenoy <ego@in.ibm.com>
References: <d82e647a0904050253n31bd2654s9b216465eec4d038@mail.gmail.com> <200904081247.08712.rusty@rustcorp.com.au> <1239194906.13185.93.camel@twins>
In-Reply-To: <1239194906.13185.93.camel@twins>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904090915.18644.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 April 2009 22:18:26 Peter Zijlstra wrote:
> On Wed, 2009-04-08 at 12:47 +0930, Rusty Russell wrote:
> > On Tuesday 07 April 2009 16:35:53 Peter Zijlstra wrote:
> > > On Tue, 2009-04-07 at 13:56 +0930, Rusty Russell wrote:
> > > > Looks like this will be fixed by Andrew's work-on-cpu-in-own-thread
> > > > patch which I just put out the pull request for.
> > > 
> > > Would it make sense to teach it about a short-circuit like:
> > > 
> > > work_on_cpu() {
> > > 
> > >   if (cpumask_weight(current->cpus_allowed) == 1 && 
> > >       smp_processor_id() == cpu)
> > >     return do_work_right_here();
> > 
> > Does that happen much?  I guess put a counter in and see?
> 
> Ego spotted the case where cpufreq calls it from an cpu-affine
> workqueue, it seems to me in that case its desirable to have the
> short-cut, and currently that's needed for correctness too as it will
> generate this circular lock thingy.

Well, the correctness issue is fixed by Andrew's work_on_cpu-via-new-thread
patch (hmm, which Linus hasn't taken, re-xmitting).

So it's really a pure optimization.

Cheers,
Rusty.
