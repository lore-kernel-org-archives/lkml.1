Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802AbZIMQWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbZIMQWX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 12:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbZIMQWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 12:22:20 -0400
Received: from fifo99.com ([67.223.236.141]:37061 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbZIMQWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 12:22:19 -0400
Subject: Re: [PATCH tip/core/rcu 2/4] Add debug checks to TREE_PREEMPT_RCU
 for premature grace periods.
From: Daniel Walker <dwalker@fifo99.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu
In-Reply-To: <12528585111986-git-send-email->
References: <20090913161438.GA32550@linux.vnet.ibm.com>
	 <12528585111986-git-send-email->
Content-Type: text/plain
Date: Sun, 13 Sep 2009 09:23:02 -0700
Message-Id: <1252858982.28368.171.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-13 at 09:15 -0700, Paul E. McKenney wrote:
> From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Check to make sure that there are no blocked tasks for the previous
> grace period while initializing for the next grace period, verify
> that rcu_preempt_qs() is given the correct CPU number and is never
> called for an offline CPU.
> 

You've got a couple of whitespace issues in the WARN_ON_ONCE() lines..
As found by checkpatch,

ERROR: code indent should use tabs where possible
#97: FILE: kernel/rcutree_plugin.h:89:
+^I    ^IWARN_ON_ONCE(cpu != smp_processor_id());$

ERROR: code indent should use tabs where possible
#109: FILE: kernel/rcutree_plugin.h:111:
+^I    ^IWARN_ON_ONCE((rdp->grpmask & rnp->qsmaskinit) == 0);$


Could you fix these up?

Daniel

