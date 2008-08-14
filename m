Return-Path: <linux-kernel-owner+w=401wt.eu-S1757035AbYHNUbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035AbYHNUbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 16:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbYHNUb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 16:31:28 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:52538 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752046AbYHNUb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 16:31:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAJQwpEhMRKxB/2dsb2JhbACBYrU1gVU
Date: Thu, 14 Aug 2008 16:31:22 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
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
Message-ID: <20080814203122.GC7896@Krystal>
References: <48A3A806.8060509@goop.org> <20080814151805.GA29507@Krystal> <48A459B1.2070601@zytor.com> <20080814165802.GC517@Krystal> <48A465F2.8000701@goop.org> <20080814173021.GA4697@Krystal> <48A46EC2.1010301@goop.org> <48A47B83.3090408@zytor.com> <20080814185338.GB7896@Krystal> <48A487A6.9060501@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48A487A6.9060501@goop.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:24:23 up 71 days,  1:04,  8 users,  load average: 1.24, 0.88,
	0.70
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> Mathieu Desnoyers wrote:
>> So should I wait a bit for more comments or straightforwardly submit
>> this as a patch rather than RFC ?
>>   
>
> Looks like all the relevant people have reviewed it now, so I don't think 
> there's much more to say.
>
>    J

I'm just worried about this comment from Harvey Harrison :

arch/x86/mm/fault.c : is_prefetch()

                         * Values 0x26,0x2E,0x36,0x3E are valid x86 prefixes.
                         * In X86_64 long mode, the CPU will signal invalid
                         * opcode if some of these prefixes are present so
                         * X86_64 will never get here anyway
                         */

This comment refers to :

0x26 : ES segment override prefix
0x2E : CS segment override prefix
0x36 : SS segment override prefix
0x3E : DS segment override prefix

AMD documentation seems to indicate that these prefix will be null, not
that the cpu would signal "invalid opcodes" :

"AMD 64-Bit Technology" A.7
http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/x86-64_overview.pdf

"In 64-bit mode, the DS, ES, SS and CS segment-override prefixes have no effect.
These four prefixes are no longer treated as segment-override prefixes in the
context of multipleprefix rules. Instead, they are treated as null prefixes."

Intel does not seem to state anything particular about these prefixes
for the 64-bit mode.

So, is this comment misleading, or is it using the term "invalid opcode"
in a way that does not imply generating a fault ?

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
