Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814AbZBVDjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbZBVDjd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 22:39:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbZBVDjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 22:39:24 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47177 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbZBVDjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 22:39:23 -0500
Date: Sun, 22 Feb 2009 12:38:22 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH] new irq tracer
Cc: kosaki.motohiro@jp.fujitsu.com, Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, mingo@elte.hu,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       acme@ghostprotocols.net, fweisbec@gmail.com, compudj@krystal.dyndns.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
In-Reply-To: <20090220195236.GB3104@redhat.com>
References: <1234995035.4799.14.camel@laptop> <20090220195236.GB3104@redhat.com>
Message-Id: <20090222123543.359C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  /**
>   * handle_IRQ_event - irq action chain handler
>   * @irq:	the interrupt number
> @@ -354,7 +358,9 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
>  		local_irq_enable_in_hardirq();
>  
>  	do {
> +		trace_irq_entry(irq);
>  		ret = action->handler(irq, action->dev_id);
> +		trace_irq_exit(irq, ret);
>  		if (ret == IRQ_HANDLED)
>  			status |= action->flags;
>  		retval |= ret;

Nobdy want unnecessary redundant tracepoint.
Please discuss with mathieu, and merge his tracepoint.



