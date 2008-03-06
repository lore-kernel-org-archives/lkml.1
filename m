Return-Path: <linux-kernel-owner+w=401wt.eu-S1757886AbYCFIvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbYCFIvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 03:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbYCFIvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 03:51:15 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:53898 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbYCFIvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 03:51:14 -0500
From: Stephan Diestelhorst <langer_mann@web.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/1] Speedfreq-SMI call clobbers ECX
Date: Thu, 6 Mar 2008 09:51:10 +0100
User-Agent: KMail/1.9.6
Cc: davej@codemonkey.org.uk, cpufreq@lists.linux.org.uk,
       linux-kernel@vger.kernel.org
References: <200803051559.09962.langer_mann@web.de> <20080305153520.GB19300@elte.hu> <200803060938.20944.langer_mann@web.de>
In-Reply-To: <200803060938.20944.langer_mann@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803060951.12002.langer_mann@web.de>
X-Provags-ID: V01U2FsdGVkX19JrtnUKgvRMmrQoAofzfRcjTivIPF4AmVrxs4s
	WfqEVXYMcwR2cUjpqETCIwsqN34yL4vxD05v8WIxueVXK6hTRF
	kIV+1aWUE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On, March 5th 2008 16:35:20 Ingo Molnar wrote:
> > * Stephan Diestelhorst <langer_mann@web.de> wrote:
> > > @@ -184,7 +184,7 @@ static void speedstep_set_state (unsigne
> > >  		__asm__ __volatile__(
> > >  			"movl $0, %%edi\n"
> > >  			"out %%al, (%%dx)\n"
> > > -			: "=b" (new_state), "=D" (result)
> > > +			: "=b" (new_state), "=D" (result), "=c" (ecx_clobber)
> > >
> > >  			: "a" (command), "b" (function), "c" (state), "d"
> > >  			: (smi_port), "S" (0)
> > >
> > >  			);
> >
> > stupid suggestion: why not do a pusha/popa around those
> > instructions, to make sure everything is restored? This isnt a
> > fastpath and being conservative about SMI side-effects cannot
> > hurt

Stephan Diestelhorst wrote:
> That sounds like a sane thing to do to me. Should I provide a
> 'patch'? Or leave that (and the decision about it) to the
> maintainer?

H. Peter Anvin wrote: 
> You can't pusha/popa if you expect a result.  You can, of course,
> push and pop individual registers.
>
> It's also kind of odd to do "movl $0,%%edi" instead of just setting
> EDI as an input.

Whoops, HPA is correct, of course. Manually pushing / popping the 
registers is ugly, how about a larger clobber-list? Let the compiler 
figure out what it wants to save/restore. Only thing to worry about 
is EBP then.

Again, should I provide these patches? This thing just annoyed me for 
a while as I have been patching it in my personal kernels for too 
long.

Regards,
  Stephan

PS: I'm not on LKML, please CC me at your discretion.
