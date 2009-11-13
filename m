Return-Path: <linux-kernel-owner+w=401wt.eu-S1753874AbZKMGeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbZKMGeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 01:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbZKMGeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 01:34:18 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34497 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249AbZKMGeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 01:34:17 -0500
Date: Thu, 12 Nov 2009 22:34:39 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: [PATCH tip/core/rcu 0/2] rcu: further grace-period processing
	cleanups
Message-ID: <20091113063439.GA560@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set provides a couple of additional grace-period-processing
cleanups:

1.	Propagate ->completed through the rcu_node hierarchy
	when RCU goes idle to prevent an additional needless
	grace period from being started.

2.	Make force_quiescent_state() take a snapshot of ->gpnum-1
	rather than ->completed for consistency with rcu_sched_qs()
	and friends.
