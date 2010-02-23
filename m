Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab0BWN2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 08:28:20 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:38912 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881Ab0BWN2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 08:28:19 -0500
Date: Tue, 23 Feb 2010 05:28:15 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 0/21] v6 add lockdep-based diagnostics to
	rcu_dereference()
Message-ID: <20100223132815.GA6873@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100223010435.GA666@linux.vnet.ibm.com> <201002231359.07910.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002231359.07910.arnd@arndb.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 01:59:07PM +0100, Arnd Bergmann wrote:
> On Tuesday 23 February 2010, Paul E. McKenney wrote:
> > This patch series adds lockdep-based checking to the rcu_dereference()
> > primitive in order to flag misuses of RCU.
> 
> While I haven't looked much at this series, I've been thinking about
> adding static diagnostics for rcu_dereference misuse, in the form of
> an __rcu address space qualifier for pointers. Such a patch would
> obviously conflict with this series, so I'd wait for yours to go
> in first, but maybe you like the idea enough to do it yourself ;-).
> 
> The observation is that all accesses to an RCU protected pointer
> are either through rcu_dereference, rcu_assign_pointer or one of their
> variants. so it should be possible to add a new address space like we
> have for __iomem, __user and soon __percpu and have sparse check that
> we use RCU consistently on pointers that need it.

That is orthogonal to the current series, but sounds like a very good
idea, give or take how to handle initialization accesses and the like.

Your approach would verify that a given RCU-protected pointer is
consistently handled by rcu_dereference() and presumably also
rcu_assign_pointer().  This patch series instead verifies that a given
rcu_dereference() is protected by the proper flavor of RCU or the
correct lock or whatever else.

							Thanx, Paul
