Return-Path: <linux-kernel-owner+w=401wt.eu-S1757732AbYKUSJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732AbYKUSJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 13:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbYKUSJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 13:09:47 -0500
Received: from cpe-67-49-92-118.socal.res.rr.com ([67.49.92.118]:57424 "EHLO
	mail.blackbean.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567AbYKUSJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 13:09:46 -0500
Date: Fri, 21 Nov 2008 10:09:29 -0800
From: Jim Radford <radford@galvanix.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: mcount record based dynamic tracing for ARM
Message-ID: <20081121180929.GA13863@blackbean.org>
References: <20081118231525.GA16081@blackbean.org> <alpine.DEB.1.10.0811201734050.14652@gandalf.stny.rr.com> <20081120224903.GA3244@blackbean.org> <alpine.DEB.1.10.0811202114560.4464@gandalf.stny.rr.com> <20081121035509.GA5266@blackbean.org> <alpine.DEB.1.10.0811210917380.6447@gandalf.stny.rr.com> <20081121153827.GA8433@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121153827.GA8433@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 03:38:27PM +0000, Russell King - ARM Linux wrote:
> On Fri, Nov 21, 2008 at 09:27:17AM -0500, Steven Rostedt wrote:
> > On Thu, 20 Nov 2008, Jim Radford wrote:
> > > -	select HAVE_FUNCTION_TRACER if (!XIP_KERNEL)
> > > +	select HAVE_FTRACE_MCOUNT_RECORD
> > > +	select HAVE_DYNAMIC_FTRACE if (!XIP_KERNEL)

> > Russell mentioned something about the code not being compatible
> > with Thumb2, is the above if statement enough?

> We've started on merging some of the pre-requisits, and it will mean
> that the instruction length is no longer constant.  (It may be a
> 16bit or 32bit instruction.)

The only instruction that matters for arm is "bl <func>" since that's
what's emitted by gcc to call mcount().  I suspect thumb will be easy
to support.  <func> isn't known when the file is compiled, so I assume
in that case the assembler will have to leave at least 4 bytes (even
in thumb) in case mcount() gets linked far away.

I haven't looked at the return tracing code yet.  That might be harder
to support, but given x86 works, I suspect it'll be doable.

-Jim
