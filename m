Return-Path: <linux-kernel-owner+w=401wt.eu-S936159AbXHHFfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936159AbXHHFfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 01:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933307AbXHHFdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 01:33:07 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:32868 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934869AbXHHFdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 01:33:03 -0400
Date: Tue, 7 Aug 2007 22:32:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       mingo@elte.hu, akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       tglx@linutronix.de
Subject: Re: [PATCH 3/4 RFC] RCU: preemptible RCU
Message-ID: <20070808053256.GA5024@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070807183946.GA32110@linux.vnet.ibm.com> <20070807184812.GC10068@linux.vnet.ibm.com> <1186514309.11797.171.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186514309.11797.171.camel@lappy>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 09:18:29PM +0200, Peter Zijlstra wrote:
> On Tue, 2007-08-07 at 11:48 -0700, Paul E. McKenney wrote:
> > This patch implements a new version of RCU which allows its read-side
> > critical sections to be preempted. It uses a set of counter pairs
> > to keep track of the read-side critical sections and flips them
> > when all tasks exit read-side critical section. The details
> > of this implementation can be found in this paper -
> > 
> > http://www.rdrop.com/users/paulmck/RCU/OLSrtRCU.2006.08.11a.pdf
> > 
> > This patch was developed as a part of the -rt kernel development and
> > meant to provide better latencies when read-side critical sections of
> > RCU don't disable preemption.  As a consequence of keeping track of RCU
> > readers, the readers have a slight overhead (optimizations in the paper).
> > This implementation co-exists with the "classic" RCU implementations
> > and can be switched to at compiler.
> > 
> > Also includes RCU tracing summarized in debugfs and RCU_SOFTIRQ for
> > the preemptible variant of RCU.
> 
> Whickedly complex but very cool stuff!
> 
> Unfortunately I have nothing to contribute other than praise at the
> complex yet elegant way you dodged the need for synchronisation.

I am glad you like it!  Heck, I may have to print this email out,
frame it, and hang it on my cube wall.  ;-)

						Thanx, Paul
