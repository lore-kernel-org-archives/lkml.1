Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135Ab0AUQMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab0AUQMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 11:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010Ab0AUQMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 11:12:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62767 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab0AUQMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 11:12:17 -0500
X-Authority-Analysis: v=1.0 c=1 a=r_nf4N-T2GkA:10 a=7U3hwN5JcxgA:10 a=JfrnYn6hAAAA:8 a=Ai0_PIA094CE5r39QX8A:9 a=3yVElQzVrzAglUFcf_oA:7 a=iyRZpbX_qfxvOK4jrbAvGrNhO_EA:4 a=3Rfx1nUSh_UA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier (v5)
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
In-Reply-To: <20100121160729.GB12842@Krystal>
References: <1263460096.4244.282.camel@laptop>
	 <20100114162609.GC3487@Krystal> <1263488625.4244.333.camel@laptop>
	 <20100114175449.GA15387@Krystal> <20100114183739.GA18435@Krystal>
	 <1263495132.28171.3861.camel@gandalf.stny.rr.com>
	 <20100114193355.GA23436@Krystal> <1263926259.4283.757.camel@laptop>
	 <1263928006.4283.762.camel@laptop> <1264073212.4283.1158.camel@laptop>
	 <20100121160729.GB12842@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 21 Jan 2010 11:12:11 -0500
Message-ID: <1264090331.31321.212.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-21 at 11:07 -0500, Mathieu Desnoyers wrote:
> * Peter Zijlstra (peterz@infradead.org) wrote:

> We can even create a generic fallback with the following kind of code in
> the meantime:
> 
> static inline void spin_lock_mb(spinlock_t *lock)
> {
> 	spin_lock(&lock);

That would be spin_lock(lock);

> 	smp_mb();
> }
> 
> static inline void spin_unlock_mb(spinlock_t *lock)
> {
> 	smp_mb();
> 	spin_unlock(&lock);

and spin_unlock(lock);

;-)

> }
> 
> How does that sound ?

You may also need spin_lock_irqsave, et al. variants too.

-- Steve


