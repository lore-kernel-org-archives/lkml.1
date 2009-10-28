Return-Path: <linux-kernel-owner+w=401wt.eu-S1754431AbZJ1PQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbZJ1PQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 11:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754409AbZJ1PQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 11:16:33 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39229 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295AbZJ1PQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 11:16:33 -0400
Date: Wed, 28 Oct 2009 08:14:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: [PATCH tip/core/rcu 0/2] RCU force_quiescent_state() fix and
	dyntick cleanup
Message-ID: <20091028151419.GA7838@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains a cleanup and a fix:

o	Code cleanup from Lai Jiangshan that makes the calls to
	rcu_irq_enter() and rcu_irq_exit() more obviously correct.
	The previous code worked because rcu_irq_exit() is always
	an empty function if !NO_HZ.

o	Fix a low-probability race in the TREE_RCU infrastructure
	that can be triggered by extremely long grace periods.

						Thanx, Paul
