Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbZLBXVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbZLBXVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 18:21:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755478AbZLBXVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 18:21:04 -0500
Received: from relay1-v.mail.gandi.net ([217.70.178.75]:49270 "EHLO
	relay1-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbZLBXVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 18:21:04 -0500
Date: Wed, 2 Dec 2009 15:20:57 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 1/4] rcu: rename "quiet" functions
Message-ID: <20091202232056.GA5479@feather>
References: <20091202200955.GA12950@linux.vnet.ibm.com>
 <12597846163698-git-send-email->
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12597846163698-git-send-email->
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 12:10:13PM -0800, Paul E. McKenney wrote:
> The number of "quiet" functions has grown recently, and the names are
> no longer very descriptive.  The point of all of these functions is to
> do some portion of the task of reporting a quiescent state, so rename
> them accordingly:
> 
> o	cpu_quiet() becomes rcu_report_qs_rdp(), which reports a
> 	quiescent state to the per-CPU rcu_data structure.  If this
> 	turns out to be a new quiescent state for this grace period,
> 	then rcu_report_qs_rnp() will be invoked to propagate the
> 	quiescent state up the rcu_node hierarchy.
> 
> o	cpu_quiet_msk() becomes rcu_report_qs_rnp(), which reports
> 	a quiescent state for a given CPU (or possibly a set of CPUs)
> 	up the rcu_node hierarchy.
> 
> o	cpu_quiet_msk_finish() becomes rcu_report_qs_rsp(), which
> 	reports a full set of quiescent states to the global rcu_state
> 	structure.
> 
> o	task_quiet() becomes rcu_report_unblock_qs_rnp(), which reports
> 	a quiescent state due to a task exiting an RCU read-side critical
> 	section that had previously blocked in that same critical section.
> 	As indicated by the new name, this type of quiescent state is
> 	reported up the rcu_node hierarchy (using rcu_report_qs_rnp()
> 	to do so).
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

*Huge* improvement in terminology.

Acked-by: Josh Triplett <josh@joshtriplett.org>
