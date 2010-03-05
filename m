Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab0CEXDB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 18:03:01 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:49976 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755358Ab0CEXC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 18:02:59 -0500
Date: Fri, 5 Mar 2010 15:02:56 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: [PATCH tip/core/rcu 0/3] rcu: ftrace&x86/mce RCU lockdep fixes,
	extend RCU CPU stall
Message-ID: <20100305230256.GA9410@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch set gets rid of read_barrier_depends() in ftrace in favor of
RCU APIs, increases the RCU CPU stall timeout if CONFIG_PROVE_RCU, and
fixes an x86/mce lockdep splat.

							Thanx, Paul

------------------------------------------------------------------------

 arch/x86/kernel/cpu/mcheck/mce.c |   12 ++++++++----
 kernel/rcutree.h                 |   22 +++++++++++++++-------
 kernel/trace/ftrace.c            |   23 +++++++++++++----------
 3 files changed, 36 insertions(+), 21 deletions(-)
