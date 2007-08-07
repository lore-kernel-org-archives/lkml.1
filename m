Return-Path: <linux-kernel-owner+w=401wt.eu-S1760844AbXHGSj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760844AbXHGSj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 14:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbXHGSjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 14:39:49 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47705 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbXHGSjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 14:39:48 -0400
Date: Tue, 7 Aug 2007 11:39:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-rt-users@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, tytso@us.ibm.com,
       dvhltc@us.ibm.com, tglx@linutronix.de
Subject: [PATCH 0/4 RFC] preemptible RCU
Message-ID: <20070807183946.GA32110@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patchset is an update of that posted by Dipankar last January
(http://lkml.org/lkml/2007/1/15/133).  This is work in progress, not yet
ready for inclusion.  It passes rcutorture on i386, x86_64, and ppc64
boxes as well as kernbench, so should be safe for experimentation.  As
with Dipankar's previous post, this variant of preemptible rcu_read_lock()
and rcu_read_unlock may be invoked from NMI/SMI handlers, and do not
contain any heavyweight atomic operations or memory barriers (although
they do still momentarily disable IRQs).  This patchset features
a fully parallel grace-period computation, which will become increasingly
important with upcoming multicore/multi-threaded CPUs.  In addition,
this patchset provides a preemptible-RCU variant of synchronize_sched()
that avoids the previous deadlock with CPU hotplug -- this variant may
eventually prove unnecessary, but is offered in the spirit of separating
concerns.

Next steps:  (1) Integrate with CPU hotplug.  (2) Re-merge RCU priority
boosting.  (3) Fix some naming issues.  Longer term work includes
optimized dyntick operation and eliminating the interrupt disabling
in rcu_read_lock() and rcu_read_unlock().

						Thanx, Paul
