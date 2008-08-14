Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbYHNBt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbYHNBt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 21:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbYHNBts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 21:49:48 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:41862 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbYHNBtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 21:49:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjIFABEqo0hMRKxB/2dsb2JhbACBYLR9gVU
Date: Wed, 13 Aug 2008 21:49:44 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
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
Subject: Re: [RFC PATCH] x86 alternatives : fix LOCK_PREFIX race with
	preemptible kernel and CPU hotplug
Message-ID: <20080814014944.GA31883@Krystal>
References: <alpine.DEB.1.10.0808082113090.3707@gandalf.stny.rr.com> <20080813175213.GA8679@Krystal> <alpine.LFD.1.10.0808131119290.3462@nehalem.linux-foundation.org> <20080813184142.GM1366@one.firstfloor.org> <20080813193011.GC15547@Krystal> <20080813193715.GQ1366@one.firstfloor.org> <20080813200119.GA18966@Krystal> <20080813234156.GA25775@Krystal> <48A375E3.9090609@zytor.com> <48A388CE.2020404@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48A388CE.2020404@goop.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:44:39 up 70 days,  6:25,  6 users,  load average: 0.20, 0.35,
	0.36
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> H. Peter Anvin wrote:
>> I believe this should be okay.  In 32-bit mode some of the security and 
>> hypervisor frameworks want to set segment limits, but I don't believe they 
>> ever would set DS and SS inconsistently, or that we'd handle a #GP versus 
>> an #SS differently (segment violations on the stack segment are #SS, not 
>> #GP.)  To be 100% sure we'd have to pick apart the modr/m byte to figure 
>> out what the base register is but I think that's total overkill.
>
> The kernel sets ds and ss to the same selector, so they're always going to 
> have the same underlying descriptor.
>
> My only concern is whether there are any locked instructions which are 
> explicitly using a cs: override for those odd corners of the kernel.  I 
> don't think so.
>
> That said, I wonder how useful it is to do the SMP->UP code transition.  
> How often does a kernel go from being SMP to UP in a situation where we 
> really care about the performance?  And that won't be shortly be becoming 
> SMP again anyway?
>

A virtualized guest kernel could use that to limit its use of the
overall machine CPU resources in different time periods. Policies can
determine how many physical CPU a virtual machine can be tied to, and
that may change depending on e.g. the workload or time of day. Having
the ability to efficiently switch to UP for a long period of time seems
important in this use-case.

Mathieu

>    J

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
