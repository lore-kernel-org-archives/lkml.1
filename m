Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab0CFB5x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 20:57:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63401 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab0CFB5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 20:57:52 -0500
X-Authority-Analysis: v=1.0 c=1 a=KDX7HhSo8L4A:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=a0DulWFBjFRnok6R2WIA:9 a=s5Fma-6LxZYGpxv8hR6UBwOQBZ8A:4 a=PUjeQqilurYA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH tip/core/rcu 1/3] ftrace: replace
 read_barrier_depends() with rcu_dereference_raw()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Josh Triplett <josh@joshtriplett.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
In-Reply-To: <20100306014513.GA13858@feather>
References: <20100305230256.GA9410@linux.vnet.ibm.com>
	 <1267830207-9474-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1267838945.10871.1786.camel@gandalf.stny.rr.com>
	 <20100306014513.GA13858@feather>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 05 Mar 2010 20:57:49 -0500
Message-ID: <1267840669.10871.1790.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-05 at 17:45 -0800, Josh Triplett wrote:

> > #define rcu_assign_pointer(p, v) \
> > 	({ \
> > 		if (!__builtin_constant_p(v) || \
> > 		    ((v) != NULL)) \
> > 			smp_wmb(); \
> > 		(p) = (v); \
> > 	})
> > 
> > My question is, why that crazy if? The only time that will fail is if we
> > are assigning the constant NULL to p. What makes NULL so important here?
> > Can't there be a case when assigning NULL to p will require that wmb()?
> 
> The barrier ensures that the reader can't see the new p and the old
> *p.  Since you can't look at *NULL, that concern doesn't apply.

Thanks for the explanation.

Question 2)

Then why the !__builtin_constant_p(v)?

If v is NULL, then the same should apply even if it is not a constant?
What am I missing?

-- Steve


