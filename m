Return-Path: <linux-kernel-owner+w=401wt.eu-S1753227AbYKRPHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbYKRPHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 10:07:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYKRPG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 10:06:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64124 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbYKRPG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 10:06:58 -0500
Date: Tue, 18 Nov 2008 10:06:57 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/function-return-tracer: add the overrun
 field
In-Reply-To: <20081118145154.GC30358@elte.hu>
Message-ID: <alpine.DEB.1.10.0811181006010.15003@gandalf.stny.rr.com>
References: <4920D571.4050007@gmail.com> <20081117084923.GD28786@elte.hu> <4921BA25.3090704@gmail.com> <20081118084755.GK17838@elte.hu> <alpine.DEB.1.10.0811180922370.15003@gandalf.stny.rr.com> <20081118145154.GC30358@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 18 Nov 2008, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > On Tue, 18 Nov 2008, Ingo Molnar wrote:
> > > > 
> > > > Ok I will try with 50. If there are still a lot and often missing 
> > > > traces with this depth, perhaps should we consider a hybrid solution 
> > > > between ret stack and trampolines? We could use the normal ret stack 
> > > > on struct info for most common cases and the trampoline when we are 
> > > > exceeding the depth....
> > > 
> > > dunno, trampolines make me feel uneasy.
> > > 
> > > Could you set it to some really large value (200) and add a "max 
> > > depth seen" variable perhaps, and see the maximum depth?
> > 
> > Don't run that on a box you care about ;-) But hopefully the stacks 
> > will not collide. This should also depend on IRQSTACKS.
> 
> that reminds me: ti->ret_stack[] should be moved to task->ret_stack[]. 
> That way we decouple its size from any kernel stack size limits. 
> (thread-info resides at one end of the kernel stack, on x86)

Yeah, I recommended that to Frederic to save space. But that can be 
dangerous. Using task instead would be safer with the downside of making 
the task struct even bigger.

-- Steve

