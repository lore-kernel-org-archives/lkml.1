Return-Path: <linux-kernel-owner+w=401wt.eu-S1751585AbZLHJD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbZLHJD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 04:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbZLHJDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 04:03:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:43389 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbZLHJDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 04:03:19 -0500
Subject: Re: [PATCH 4/7] sched: implement force_cpus_allowed()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, efault@gmx.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4B1E1130.9050108@kernel.org>
References: <1259726212-30259-1-git-send-email-tj@kernel.org>
	 <1259726212-30259-5-git-send-email-tj@kernel.org>
	 <1259923259.3977.1928.camel@laptop> <1259923381.3977.1934.camel@laptop>
	 <4B1C85D3.3080401@kernel.org> <1260174900.8223.1159.camel@laptop>
	 <4B1CDA1C.3000802@kernel.org> <1260183278.8223.1500.camel@laptop>
	 <4B1CE1E8.2070803@kernel.org>  <4B1E1130.9050108@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Dec 2009 10:02:43 +0100
Message-ID: <1260262963.3935.1002.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-08 at 17:41 +0900, Tejun Heo wrote:
> Hello,
> 
> On 12/07/2009 08:07 PM, Tejun Heo wrote:
> > On 12/07/2009 07:54 PM, Peter Zijlstra wrote:
> >> So we seem to do cleanup_workqueue_thread() from CPU_POST_DEAD, but at
> >> that time any thread that might still be around will most certainly not
> >> be running on the offlined cpu anymore.
> >>
> >> If you really want to ensure you remain on the cpu, you have to complete
> >> from CPU_DOWN_PREPARE.
> >>
> >> We're not running things from offline CPUs.
> > 
> > Oh, no, we're not doing that.  We can't do that.  What we're doing is
> > to continue to process works which were queued on the now offline cpu
> > unless it has been flushed/cancled from one of the cpu down
> > notifications and the reason why we need to be able to fork after
> > active is clear is to guarantee those flush/cancels don't deadlock.
> 
> Does my explanation justify the patch?

So its only needed in order to flush a workqueue from CPU_DOWN_PREPARE?
And all you need it to place a new kthread on a !active cpu?

Or is this in order to allow migrate_live_tasks() to move the worker
threads away from the dead cpu?

I'm really not thrilled by the whole fork-fest workqueue design.



