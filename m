Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364Ab0AGRAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab0AGRAM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 12:00:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315Ab0AGRAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 12:00:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49829 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab0AGRAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 12:00:09 -0500
X-Authority-Analysis: v=1.0 c=1 a=r_nf4N-T2GkA:10 a=7U3hwN5JcxgA:10 a=iR9jP0Uz3At3W5dTll4A:9 a=BA7CdGX3dofgYaBFIvgA:7 a=GZuCNqDRdqQE-NvBJcTEt_BXk24A:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: paulmck@linux.vnet.ibm.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com
In-Reply-To: <20100107164946.GD6764@linux.vnet.ibm.com>
References: <20100107044007.GA22863@Krystal>
	 <1262842854.28171.3710.camel@gandalf.stny.rr.com>
	 <20100107164946.GD6764@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 07 Jan 2010 12:00:04 -0500
Message-ID: <1262883604.28171.3733.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 08:49 -0800, Paul E. McKenney wrote:

> > If the task->rq changes, or the task->rq->curr changes, and makes the
> > condition fail (or even pass), the events that cause those changes are
> > probably good enough than needing to call smp_mb();
> 
> This narrows the fatal window, but does not eliminate it.  :-(
> 
> The CPU doing the sys_membarrier() might see an old value of ->curr,
> and the other CPU might see an old value of whatever pointer we are
> trying to recycle.  This combination is fatal.

But for curr to change, the rq spin lock must have been held. Which
implies smp_wb(). I would think that if you do a smp_rb() wouldn't that
guarantee that you see the new value of curr?

-- Steve


