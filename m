Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbYHNSqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbYHNSqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 14:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbYHNSpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 14:45:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46662 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbYHNSpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 14:45:54 -0400
Message-ID: <48A47B83.3090408@zytor.com>
Date: Thu, 14 Aug 2008 11:37:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
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
References: <20080813200119.GA18966@Krystal> <20080813234156.GA25775@Krystal> <48A375E3.9090609@zytor.com> <48A388CE.2020404@goop.org> <20080814014944.GA31883@Krystal> <48A3A806.8060509@goop.org> <20080814151805.GA29507@Krystal> <48A459B1.2070601@zytor.com> <20080814165802.GC517@Krystal> <48A465F2.8000701@goop.org> <20080814173021.GA4697@Krystal> <48A46EC2.1010301@goop.org>
In-Reply-To: <48A46EC2.1010301@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> Ah, OK.  I'd thought we started unlocked, but given that I've just been 
> disassembling the kernel and looking at the lock prefixes, that's a bit 
> of a braino on my part.
> 
> BTW, using the ds prefix allows us to undo the hack of dealing with 
> locked instructions with exception handlers.  There was a bug where if 
> we do lock->nop, then the address of a faulting instruction changes, so 
> we need exception records for both the locked and unlocked forms.  Using 
> ds means the instruction size doesn't change, so we only need one 
> exception record.  I don't remember off hand where that happens.
> 

Using %ds: rather than nop really seems to solve a whole lot of 
problems, and might even be faster to boot.  It really sounds like a 
no-brainer.

	-hpa
