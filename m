Return-Path: <linux-kernel-owner+w=401wt.eu-S1754301AbYKUQiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbYKUQiE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:38:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756745AbYKUQhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:37:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33334 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728AbYKUQhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:37:50 -0500
Date: Fri, 21 Nov 2008 11:37:46 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Jim Radford <radford@galvanix.net>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: mcount record based dynamic tracing for ARM
In-Reply-To: <20081121153827.GA8433@flint.arm.linux.org.uk>
Message-ID: <alpine.DEB.1.10.0811211136330.18505@gandalf.stny.rr.com>
References: <20081118231525.GA16081@blackbean.org> <alpine.DEB.1.10.0811201734050.14652@gandalf.stny.rr.com> <20081120224903.GA3244@blackbean.org> <alpine.DEB.1.10.0811202114560.4464@gandalf.stny.rr.com> <20081121035509.GA5266@blackbean.org>
 <alpine.DEB.1.10.0811210917380.6447@gandalf.stny.rr.com> <20081121153827.GA8433@flint.arm.linux.org.uk>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 21 Nov 2008, Russell King - ARM Linux wrote:

> On Fri, Nov 21, 2008 at 09:27:17AM -0500, Steven Rostedt wrote:
> > On Thu, 20 Nov 2008, Jim Radford wrote:
> > > -	select HAVE_FUNCTION_TRACER if (!XIP_KERNEL)
> > > +	select HAVE_FTRACE_MCOUNT_RECORD
> > > +	select HAVE_DYNAMIC_FTRACE if (!XIP_KERNEL)
> > 
> > Russell mentioned something about the code not being compatible with 
> > Thumb2, is the above if statement enough?
> 
> I think I said (or should've said) "upcoming Thumb 2" - it's not yet in
> the kernel but there's a patch series floating around for it.  We've
> started on merging some of the pre-requisits, and it will mean that
> the instruction length is no longer constant.  (It may be a 16bit or
> 32bit instruction.)
> 
> I suspect that ftrace won't be able to handle that, so it may have to
> depend on !THUMB2_KERNEL for the time being.

Actually it depends on how the compiler adds the mcount call. That's all 
that ftrace touches. The call to mcount. If all callers to mcount stay as 
32 bit, then it may still work.

-- Steve
