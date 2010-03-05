Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab0CERBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 12:01:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64608 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab0CERBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 12:01:19 -0500
X-Authority-Analysis: v=1.0 c=1 a=LlVAwFlVdBAA:10 a=7U3hwN5JcxgA:10 a=SZzF91JWWS9yEyK7Zs4A:9 a=wPpoZY61CpDxss6CuvPDG3I2NQkA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 0/26] oprofile: Performance counter multiplexing
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Robert Richter <robert.richter@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Paul Mackerras <paulus@samba.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20100305164615.GY13205@erda.amd.com>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
	 <20090803112220.GA22936@elte.hu> <20090803072522.1d90f15c@infradead.org>
	 <20090804201109.GA21386@elte.hu> <20090805123501.GF14610@erda.amd.com>
	 <84144f020908060031vb48b983m6e6b1b521e01d6aa@mail.gmail.com>
	 <20090806105134.GD11236__37984.4768475325$1249556453$gmane$org@elte.hu>
	 <87ocjcqcdj.fsf@basil.nowhere.org>  <20100305164615.GY13205@erda.amd.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 05 Mar 2010 12:01:13 -0500
Message-ID: <1267808473.10871.1775.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-05 at 17:46 +0100, Robert Richter wrote:
> On 26.02.10 15:51:04, Andi Kleen wrote:
> > That said the biggest problem with oprofile right now that the
> > new buffer it's using is quite a lot less reliable and drops
> > events left and right on any non trivial load. That makes
> > oprofile very unreliable, especially in call graph mode.
> 
> (cc'ing Steve)
> 

Thanks.

> Andi,
> 
> the tests I run with oprofile do not indicate unreliable ring_buffer
> behavior. Maybe my use cases and loads are different. Can you describe
> a setup where this may happen for sure? What is the impact, do you
> have lost samples or inconsistent buffer data? Is the data loss in
> kernel or user space? Also, I am not aware that the ring_buffer is
> unreliable for ftrace or tracepoints, where it is heavily used. I
> really want to find the root cause here.

Yes, the ftrace ring buffer (which I believe oprofile now uses) is
lockless and re-entrant. That means if a interrupt goes off while one
event is being recorded, and that interrupt writes to the same ring
buffer, the ring buffer will be able to record it without dropping the
event.

As long as the readers keep up, no event will ever be dropped. Perhaps
you need to increase the size of the ring buffers?

-- Steve


