Return-Path: <linux-kernel-owner+w=401wt.eu-S1755044AbYHNBW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbYHNBW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 21:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbYHNBWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 21:22:48 -0400
Received: from gw.goop.org ([64.81.55.164]:58954 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbYHNBWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 21:22:48 -0400
Message-ID: <48A388CE.2020404@goop.org>
Date: Wed, 13 Aug 2008 18:22:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Steven Rostedt <srostedt@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC PATCH] x86 alternatives : fix LOCK_PREFIX race with	preemptible
 kernel and CPU hotplug
References: <alpine.DEB.1.10.0808082030500.1396@gandalf.stny.rr.com> <489CE90D.1040902@goop.org> <alpine.LFD.1.10.0808081750060.3462@nehalem.linux-foundation.org> <alpine.DEB.1.10.0808082113090.3707@gandalf.stny.rr.com> <20080813175213.GA8679@Krystal> <alpine.LFD.1.10.0808131119290.3462@nehalem.linux-foundation.org> <20080813184142.GM1366@one.firstfloor.org> <20080813193011.GC15547@Krystal> <20080813193715.GQ1366@one.firstfloor.org> <20080813200119.GA18966@Krystal> <20080813234156.GA25775@Krystal> <48A375E3.9090609@zytor.com>
In-Reply-To: <48A375E3.9090609@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> I believe this should be okay.  In 32-bit mode some of the security 
> and hypervisor frameworks want to set segment limits, but I don't 
> believe they ever would set DS and SS inconsistently, or that we'd 
> handle a #GP versus an #SS differently (segment violations on the 
> stack segment are #SS, not #GP.)  To be 100% sure we'd have to pick 
> apart the modr/m byte to figure out what the base register is but I 
> think that's total overkill.

The kernel sets ds and ss to the same selector, so they're always going 
to have the same underlying descriptor.

My only concern is whether there are any locked instructions which are 
explicitly using a cs: override for those odd corners of the kernel.  I 
don't think so.

That said, I wonder how useful it is to do the SMP->UP code transition.  
How often does a kernel go from being SMP to UP in a situation where we 
really care about the performance?  And that won't be shortly be 
becoming SMP again anyway?

    J
