Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbYFBCaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbYFBCaj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 22:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbYFBCab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 22:30:31 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51138 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753058AbYFBCaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 22:30:30 -0400
Date: Sun, 1 Jun 2008 21:30:19 -0500
From: Paul Jackson <pj@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Con Kolivas <kernel@kolivas.org>, "Derek L. Fults" <dfults@sgi.com>,
       devik <devik@cdi.cz>, Dimitri Sivanich <sivanich@sgi.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Emmanuel Pacaud <emmanuel.pacaud@univ-poitiers.fr>,
       Frederik Deweerdt <deweerdt@free.fr>, Ingo Molnar <mingo@elte.hu>,
       Matthew Dobson <colpatch@us.ibm.com>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, rostedt@goodmis.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Paul Menage <menage@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Randy.Dunlap" <rddunlap@osdl.org>, rostedt@goodmis.org,
       suresh.b.siddha@intel.com, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Inquiry: Should we remove "isolcpus= kernel boot option? (may have
 realtime uses)
Message-Id: <20080601213019.14ea8ef8.pj@sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Aside to the RealTime folks -- is there a 'realtime'
email list which I should include in this discussion?)

The kernel has a "isolcpus=" kernel boot time parameter.  This
parameter isolates CPUs from scheduler load balancing, minimizing the
impact of scheduler latencies on realtime tasks running on those CPUs.

Questions:
==========

    Do you, or someone you know, use "isolcpus="?

    Can we remove it?

    Should we remove it?

    Should we first deprecate it somehow, for a while, before
    removing it?
    
Background:
===========

In July 2004, Dimitri Sivanich <sivanich@sgi.com> proposed
"isolcpus=" for realtime isolation of CPUs from the scheduler
(http://lkml.org/lkml/2004/7/22/97).

    Ingo said of it "looks good", and Nick said "Cool."

    It appeared in 2.6.9 Linux kernels.

    It made Item #6 of Zack Brown's Kernel Traffic #272, dated Sept
    5, 2004.

    It also made LWN.net Weekly Edition for October 28, 2004, at
    http://lwn.net/Articles/107490/bigpage.
    
    Dimitri's fifteen minutes of fame had begun ;).

In April 2005, Dinakar Guniguntala <dino@in.ibm.com> proposed
dynamic scheduler domains (http://lkml.org/lkml/2005/4/18/187).

    It was immediately recognized, by Nick that this new work was a
    "complete superset of the isolcpus= functionality."

    Dinakar concurred, responding that he "was hoping that by the
    time we are done with this, we would be able to completely get
    rid of the isolcpus= option."

    To which I (pj) replied "I won't miss it.  Though, since it's
    in the main line kernel, do you need to mark it deprecated for
    a while first?"

Since then, dynamic scheduler domains and cpusets have seen much
work.  See for example http://lkml.org/lkml/2007/9/30/29, which
added the sched_load_balance flag to cpusets.

However nothing much has changed with regard to the "isolcpus=" kernel
boot time parameter.  This parameter is still there.  In October of
2006, Derek Fults <dfults@sgi.com> did extend the syntax of the CPU
list argument to the "isolcpus=" parameter to handle CPU ranges.

Some of us (perhaps not including Ingo) tend to agree "isolcpus="
should go, but I am still recommending that we "deprecate" it in some
fashion for a while first, as I am usually opposed to suddenly
removing visible kernel features, because that breaks things.

Recently:
=========

Recently, Peter Zijlstra <a.p.zijlstra@chello.nl> and Max Krasnyansky
<maxk@qualcomm.com> have been advocating removing the "isolcpus="
option.  See for example Peter's http://lkml.org/lkml/2008/2/27/378
or Max's http://lkml.org/lkml/2008/5/27/356.  I've been resisting,
still advocating that we deprecate it first, before removing it,
if that is we even agree to remove it.

Next Step:
==========

This message begins the next steps, which are:

 1) Survey the current usage of "isolcpus=".  If we find evidence
    of usage, then this should delay, or even argue against, the
    removal of this feature.

 2) Alert potential users of the change being considered here,
    so that they can plan their work to adapt if we decided to
    deprecate or remove the "isolcpus=" kernel boot parameter.

My recommendation (which may change with feedback from this inquiry)
is be to add a kernel printk, once at boot, issuing a KERN_WARN that
isolcpus is deprecated, if isolcpus was specified.  Then in some
future release, remove isolcpus (and the warning).

One possible reason for keeping "isolcpus=" could be that it is
available even when cpusets is not configured into kernel.  I don't
know if that is a case that is valuable to some or not.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
