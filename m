Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045Ab0ASA4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab0ASA4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 19:56:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754938Ab0ASA4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 19:56:53 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44331 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300Ab0ASA4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 19:56:52 -0500
Date: Mon, 18 Jan 2010 16:56:46 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 8/9] idr: apply lockdep-based diagnostics
	to rcu_dereference() uses
Message-ID: <20100119005646.GA6196@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100115010157.GA28221@linux.vnet.ibm.com> <20100118233604.GE29076@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100118233604.GE29076@feather>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 03:36:04PM -0800, Josh Triplett wrote:
> On Thu, Jan 14, 2010 at 05:02:45PM -0800, Paul E. McKenney wrote:
> > From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > Because idr can be used with any of a number of locks or with any
> > flavor of RCU, just disable the lockdep-based diagnostics.  If idr
> > needs diagnostics, the check expression will need to be passed into
> > the relevant idr primitives as an additional argument.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> The subject line of this patch seems wrong.  Like the preceding patches
> for radix tree and list operations, this *disables* the checking by
> using _raw.

It does indeed use _raw.  If we start having enough issues with these
interfaces, this will need to change.  At the moment, the obvious change
is to provide multiple interfaces as was done for rcu_dereference().
For example, idr_find(), idr_find_bh(), idr_find_sched(), idr_find_srcu(),
idr_find_rcu(), and idr_find_check().

Probably only a few of these are actually in use, but even so, I decided
to see how rcu_dereference() turned out before pushing up to the
higher-level APIs.  My guess would be that the list APIs would be most
pressing, but we will see.  ;-)

							Thanx, Paul
