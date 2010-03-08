Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab0CHPHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 10:07:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36097 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab0CHPHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 10:07:40 -0500
X-Authority-Analysis: v=1.0 c=1 a=drjUTJznMZEA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=csHddyWDuWC53NlmwnYA:9 a=0KgVS6q1dzLNK2VwybBboKP-I0cA:4 a=PUjeQqilurYA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [BUG] WARNING: at kernel/trace/ring_buffer.c:3420
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1268060596.10871.1805.camel@gandalf.stny.rr.com>
References: <4B94936B.8030409@cn.fujitsu.com>
	 <4B949E43.2010906@cn.fujitsu.com>
	 <1268060596.10871.1805.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 08 Mar 2010 10:07:38 -0500
Message-ID: <1268060858.10871.1807.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-08 at 10:03 -0500, Steven Rostedt wrote:

> > ringbuffer resizing and reseting will increase the ->record_disabled
> > and then wait until a rcu_shced grace period passes.
> > 
> > Contrarily, testing ->record_disabled should be at the same
> > preempt disabled critical region as writing into ringbuffer, otherwise
> > it will leave a window break ringbuffer resizing or reseting.
> 
> So the resizing and the resetting need a synchronize_sched() after the
> disabling of the buffers, right?

Looking at the code, the synchronize_sched() is already done in
ring_buffer_resize, and the caller (trace.c:tracing_reset() ) also
disables the ring buffer and calls synchronize_sched().

With that, what other window is still opened (after this fix)?

-- Steve



