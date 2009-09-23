Return-Path: <linux-kernel-owner+w=401wt.eu-S1751943AbZIWNVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbZIWNVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 09:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbZIWNVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 09:21:37 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44015 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbZIWNVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 09:21:36 -0400
Date: Wed, 23 Sep 2009 06:21:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 0/4] Josh and Ingo review feedback and
	bloatwatch RCU
Message-ID: <20090923132137.GE6845@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090922222443.GA3178@linux.vnet.ibm.com> <1253688342.7695.99.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253688342.7695.99.camel@twins>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 08:45:42AM +0200, Peter Zijlstra wrote:
> On Tue, 2009-09-22 at 15:24 -0700, Paul E. McKenney wrote:
> > This patch set applies two sets of review feedback from Josh Triplett and
> > checkpatch feedback from Ingo Molnar.  It also contains a forward-port
> > of Bloatwatch RCU, courtesy of David Howells.
> 
> It would be much easier to review if these patches had a changelog
> describing the problem they address :-)
> 
> The first one seems to do:
> 
> A)
>  - aggregate 'rsp->completed == rsp->gpnum' expressions into a
>    common function.
> 
>  - consistently use ACCESS_ONCE() in the above mentioned function
> 
> B)
>  - use DIV_ROUND_UP()
> 
> C)
>  - aggregate list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x01])
> expressions into a common function.
> 
> 
> Could have been three patches, but ACK.

Good point, I will re-submit with the changelog and your Acked-by.

> The second patch seems to mostly add comments, but also moves code
> around and makes it static, which could have been split in two patches.
> 
> The purpose of the move code around bit could be a cleanup?

Yep.  The main point was that the old way had a bunch of random
forward declarations, while the new way has the plugins themselves
forward-declared, which (to me at least) makes a lot more sense.

> Looks to preserve the logic, but didn't go out on a limb to verify, ACK.

Again, will re-submit with your acked-by.

> The third and fourth do have an adequate changelog :-) 

;-)

Thank you for looking this over!!!

							Thanx, Paul
