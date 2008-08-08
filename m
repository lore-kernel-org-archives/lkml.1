Return-Path: <linux-kernel-owner+w=401wt.eu-S1757631AbYHHXDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbYHHXDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 19:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759445AbYHHXCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 19:02:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38701
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752654AbYHHXCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 19:02:53 -0400
Date: Fri, 08 Aug 2008 16:02:54 -0700 (PDT)
Message-Id: <20080808.160254.223161300.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, marcin.slusarz@gmail.com,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] printk: robustify printk
From: David Miller <davem@davemloft.net>
In-Reply-To: <1218219269.29098.5.camel@lappy.programming.kicks-ass.net>
References: <1218217257.29098.2.camel@lappy.programming.kicks-ass.net>
	<alpine.LFD.1.10.0808081043160.3462@nehalem.linux-foundation.org>
	<1218219269.29098.5.camel@lappy.programming.kicks-ass.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri, 08 Aug 2008 20:14:28 +0200

> +struct klogd_wakeup_state {
> +	struct rcu_head head;
> +	int pending;
> +};
> +
> +DEFINE_PER_CPU(struct klogd_wakeup_state, kws);

Since there is not RCU_HEAD_INIT() made on these per-cpu objects, this code
is depending upon the fact that currently the RCU head is just initialized
to all zeros.
