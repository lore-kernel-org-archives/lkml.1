Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbYHNVrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbYHNVrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 17:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbYHNVrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 17:47:08 -0400
Received: from gw.goop.org ([64.81.55.164]:39971 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbYHNVrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 17:47:07 -0400
Message-ID: <48A4A7B4.3060008@goop.org>
Date: Thu, 14 Aug 2008 14:46:28 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Harvey Harrison <harvey.harrison@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
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
References: <48A3A806.8060509@goop.org> <20080814151805.GA29507@Krystal> <48A459B1.2070601@zytor.com> <20080814165802.GC517@Krystal> <48A465F2.8000701@goop.org> <20080814173021.GA4697@Krystal> <48A46EC2.1010301@goop.org> <48A47B83.3090408@zytor.com> <20080814185338.GB7896@Krystal> <48A487A6.9060501@goop.org> <20080814203122.GC7896@Krystal>
In-Reply-To: <20080814203122.GC7896@Krystal>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> I'm just worried about this comment from Harvey Harrison :
>
> arch/x86/mm/fault.c : is_prefetch()
>
>                          * Values 0x26,0x2E,0x36,0x3E are valid x86 prefixes.
>                          * In X86_64 long mode, the CPU will signal invalid
>                          * opcode if some of these prefixes are present so
>                          * X86_64 will never get here anyway
>   

I would say that comment is wrong.  But we'd never put a lock prefix on 
a prefetch, so you won't be added a ds prefix either.

    J
