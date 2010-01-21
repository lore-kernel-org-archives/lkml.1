Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310Ab0AUL2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab0AUL2N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 06:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755285Ab0AUL2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 06:28:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:44423 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab0AUL2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 06:28:11 -0500
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier (v5)
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
In-Reply-To: <1263928006.4283.762.camel@laptop>
References: <20100113013757.GA29314@Krystal>
	 <1263400738.4244.242.camel@laptop> <20100113193603.GA27327@Krystal>
	 <1263460096.4244.282.camel@laptop> <20100114162609.GC3487@Krystal>
	 <1263488625.4244.333.camel@laptop> <20100114175449.GA15387@Krystal>
	 <20100114183739.GA18435@Krystal>
	 <1263495132.28171.3861.camel@gandalf.stny.rr.com>
	 <20100114193355.GA23436@Krystal>  <1263926259.4283.757.camel@laptop>
	 <1263928006.4283.762.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jan 2010 12:26:52 +0100
Message-ID: <1264073212.4283.1158.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-19 at 20:06 +0100, Peter Zijlstra wrote:
> 
> We could possibly look at placing that assignment in context_switch()
> between switch_mm() and switch_to(), which should provide a mb before
> and after I think, Ingo?

Right, just found out why we cannot do that, the first thing
context_switch() does is prepare_context_switch() which includes
prepare_lock_switch() which on __ARCH_WANT_UNLOCKED_CTXSW machines drops
the rq->lock, and we have to have rq->curr assigned by then.



