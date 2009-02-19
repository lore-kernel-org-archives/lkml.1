Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbZBSBmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbZBSBmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 20:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbZBSBmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 20:42:14 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52349 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbZBSBmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 20:42:12 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH] new irq tracer
Cc: kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
       fweisbec@gmail.com, fche@redhat.com, peterz@infradead.org
In-Reply-To: <20090218202617.GA26625@Krystal>
References: <20090218195328.GA3112@redhat.com> <20090218202617.GA26625@Krystal>
Message-Id: <20090219103628.9559.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Thu, 19 Feb 2009 10:42:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

> * Jason Baron (jbaron@redhat.com) wrote:
> > hi,
> > 
> > Using a copule of tracepoints i've implemented an 'irq tracer' which has
> > the following column format:
> > 
> > [time][irq][action][handled][cpu][length]
> > 
> > for example on my system:
> > 
> > [ 1038.927248381]     28     eth0      1        3     0.000002745
> > [ 1038.927544688]     28     eth0      1        3     0.000002520
> > [ 1038.927593609]     28     eth0      1        3     0.000002509
> > [ 1038.974087675]     29     ahci      1        1     0.000013135
> > [ 1038.974288475]     29     ahci      1        1     0.000005542
> > [ 1038.974414324]     29     ahci      1        1     0.000007953
> > 
> > I think this patch is useful in understanding irq system behavior, and
> > for tracking down irq driver handlers that are firing too often or
> > spending too much time handling an irq. This approach could be extended
> > to the timer irq and for softirqs...
> > 
> > thanks,



> > @@ -354,7 +358,9 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
> >  		local_irq_enable_in_hardirq();
> >  
> >  	do {
> > +		trace_irq_entry(irq);
> >  		ret = action->handler(irq, action->dev_id);
> > +		trace_irq_exit(irq, ret);
> >  		if (ret == IRQ_HANDLED)
> >  			status |= action->flags;
> >  		retval |= ret;

May I ask why you select this line?

IOW, I guess your probe point is interest to irq action and mathieu's 
probe point is interest to interrupt itself.

I guess you also want to observe shared irq problem, right?


