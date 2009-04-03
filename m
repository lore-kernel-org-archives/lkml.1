Return-Path: <linux-kernel-owner+w=401wt.eu-S1764818AbZDCM2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764818AbZDCM2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 08:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764500AbZDCM2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 08:28:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44340 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764198AbZDCM2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 08:28:20 -0400
Date: Fri, 3 Apr 2009 14:26:54 +0200
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
Message-ID: <20090403122654.GA19451@elte.hu>
References: <49D4F4B5.9040107@redhat.com> <20090403112639.GC31399@elte.hu> <49D5F80B.7000305@redhat.com> <20090403121202.GI31399@elte.hu> <49D5FE42.5080100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D5FE42.5080100@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> Ingo Molnar wrote:
>>> kvm has three requirements not needed by kprobes:
>>> - it wants to execute instructions, not just decode them, including   
>>>   generating faults where appropriate
>>> - it is performance critical
>>> - it needs to support 16-bit, 32-bit, and 64-bit instructions simultaneously
>>>
>>> If an arch/x86/ decoder/emulator gives me these I'll gladly switch  
>>> to it.  x86_emulate.c is high on my list of most disliked code.
>>>     
>>
>> Well, this has to be driven from the KVM side as the kprobes use 
>> will only be for decoding so if it's modified from the kprobes 
>> side the KVM-only functionality might regress.
>>
>> So ... we can do the library decoder for kprobes purposes, and 
>> someone versed in the KVM emulator can then combine the two.
>
> Problem is, anyone versed in the kvm emulator will want to run as 
> far away from this work as possible.

Are you suggesting that the KVM emulator should never have been 
merged in the first place? ;-)

Anyway, we'll make sure the kprobes/library decoder is as clean as 
possible - so it ought to be hackable and extensible without the 
risk of permanent brain damage. Mmiotrace and kmemcheck has decoding 
smarts too, and i think the sw-breakpoint injection code of KGDB 
could use it as well - so there's broader utility in all this.

	Ingo
