Return-Path: <linux-kernel-owner+w=401wt.eu-S1759877AbYHNSxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759877AbYHNSxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 14:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYHNSxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 14:53:44 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:37140 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751286AbYHNSxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 14:53:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAJMZpEhMRKxB/2dsb2JhbACBYrVJgVU
Date: Thu, 14 Aug 2008 14:53:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <andi@firstfloor.org>,
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
Message-ID: <20080814185338.GB7896@Krystal>
References: <48A388CE.2020404@goop.org> <20080814014944.GA31883@Krystal> <48A3A806.8060509@goop.org> <20080814151805.GA29507@Krystal> <48A459B1.2070601@zytor.com> <20080814165802.GC517@Krystal> <48A465F2.8000701@goop.org> <20080814173021.GA4697@Krystal> <48A46EC2.1010301@goop.org> <48A47B83.3090408@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48A47B83.3090408@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:52:58 up 70 days, 23:33,  7 users,  load average: 3.80, 1.82,
	1.12
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Jeremy Fitzhardinge wrote:
>> Ah, OK.  I'd thought we started unlocked, but given that I've just been 
>> disassembling the kernel and looking at the lock prefixes, that's a bit of 
>> a braino on my part.
>> BTW, using the ds prefix allows us to undo the hack of dealing with locked 
>> instructions with exception handlers.  There was a bug where if we do 
>> lock->nop, then the address of a faulting instruction changes, so we need 
>> exception records for both the locked and unlocked forms.  Using ds means 
>> the instruction size doesn't change, so we only need one exception record. 
>>  I don't remember off hand where that happens.
>
> Using %ds: rather than nop really seems to solve a whole lot of problems, 
> and might even be faster to boot.  It really sounds like a no-brainer.
>
> 	-hpa

So should I wait a bit for more comments or straightforwardly submit
this as a patch rather than RFC ?

Mathieu



-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
