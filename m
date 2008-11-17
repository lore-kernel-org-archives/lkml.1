Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbYKQQTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbYKQQTN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 11:19:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYKQQS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 11:18:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49919 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbYKQQS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 11:18:58 -0500
Date: Mon, 17 Nov 2008 11:18:53 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Paul Mackerras <paulus@samba.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       linuxppc-dev@ozlabs.org, Rusty Russell <rusty@rustcorp.com.au>,
       Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 5/7] ftrace, PPC64: handle module trampolines for dyn
 ftrace
In-Reply-To: <18720.64083.306981.779763@drongo.ozlabs.ibm.com>
Message-ID: <alpine.DEB.1.10.0811171117320.8722@gandalf.stny.rr.com>
References: <20081116212428.938752312@goodmis.org> <20081116212516.000516128@goodmis.org> <18720.64083.306981.779763@drongo.ozlabs.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 17 Nov 2008, Paul Mackerras wrote:

> Steven Rostedt writes:
> 
> > +	if (!rec->arch.mod) {
> > +		if (!mod) {
> > +			printk(KERN_ERR "No module loaded addr=%lx\n",
> > +			       addr);
> > +			return -EFAULT;
> > +		}
> > +		rec->arch.mod = mod;
> > +	} else if (mod) {
> > +		printk(KERN_ERR
> > +		       "Record mod %p not equal to passed in mod %p\n",
> > +		       rec->arch.mod, mod);
> > +		return -EINVAL;
> 
> That looks wrong; surely you need an if (mod != rec->arch.mod)
> somewhere here?

BTW, the reason this still worked was because only the first instance 
passes in mod (when rec->arch.mod does not exist). After that, mod is 
NULL, so we never enter this case. But still, I will need to fix this 
(even though I thought I did).

-- Steve

