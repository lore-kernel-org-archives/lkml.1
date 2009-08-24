Return-Path: <linux-kernel-owner+w=401wt.eu-S1751830AbZHXHLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbZHXHLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 03:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbZHXHLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 03:11:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54082 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbZHXHLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 03:11:13 -0400
Subject: Re: [PATCH -tip] v3 Simplify rcu_pending()/rcu_check_callbacks()
 API
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josht@linux.vnet.ibm.com,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       rostedt@goodmis.org
In-Reply-To: <125097461311-git-send-email->
References: <20090727181401.GA14120@linux.vnet.ibm.com>
	 <125097461311-git-send-email->
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Aug 2009 09:10:16 +0200
Message-Id: <1251097816.7538.129.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-08-22 at 13:56 -0700, Paul E. McKenney wrote:
> From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> All calls from outside RCU are of the form:
> 
> 	if (rcu_pending(cpu))
> 		rcu_check_callbacks(cpu, user);
> 
> This is silly, instead we put a call to rcu_pending() in
> rcu_check_callbacks(),

It could be non-silly if rcu_pending() were a very simple inline
function, in that case it would avoid the full function call.

Still in such a case you can make rcu_check_callbacks() the inline
function which does the same and have the real function called somthing
else.

Anyway, its all moot since rcu_pending() wasn't a simple inline function
anyway, so you've replaced two function calls with one, which seems
good.
