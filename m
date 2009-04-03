Return-Path: <linux-kernel-owner+w=401wt.eu-S1762918AbZDCMM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762918AbZDCMM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 08:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756523AbZDCMMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 08:12:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41615 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbZDCMMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 08:12:44 -0400
Date: Fri, 3 Apr 2009 14:12:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Jim Keniston <jkenisto@us.ibm.com>,
       kvm@vger.kernel.org, systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip 0/6 V4] tracing: kprobe-based event tracer
Message-ID: <20090403121202.GI31399@elte.hu>
References: <49D4F4B5.9040107@redhat.com> <20090403112639.GC31399@elte.hu> <49D5F80B.7000305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D5F80B.7000305@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> Ingo Molnar wrote:
>> ok, the structure and concept looks quite good now, really nice!
>>
>> I'm wondering about something i suggested many moons ago: to look into 
>> the KVM decoder+emulator (arch/x86/kvm/x86_emulate.c).
>>
>> I remember there were some issues with that (one problem being 
>> that the KVM decoder is a special-purpose thing covering specific 
>> range of execution environments - not a near-full integer-ops 
>> decoder like the one we are aiming for here) - are there any 
>> other fundamental problems beyond 'it has to be done' ?
>>
>> Conceptually we want just a single piece of decoder logic in 
>> arch/x86/. If the KVM folks are cool with it we could factor out 
>> the KVM one into arch/x86/lib/. But ... if there are compelling 
>> reasons to leave the KVM one alone in its limited environment we 
>> can do that too.
>
> kvm has three requirements not needed by kprobes:
> - it wants to execute instructions, not just decode them, including  
>   generating faults where appropriate
> - it is performance critical
> - it needs to support 16-bit, 32-bit, and 64-bit instructions simultaneously
>
> If an arch/x86/ decoder/emulator gives me these I'll gladly switch 
> to it.  x86_emulate.c is high on my list of most disliked code.

Well, this has to be driven from the KVM side as the kprobes use 
will only be for decoding so if it's modified from the kprobes side 
the KVM-only functionality might regress.

So ... we can do the library decoder for kprobes purposes, and 
someone versed in the KVM emulator can then combine the two.

	Ingo
