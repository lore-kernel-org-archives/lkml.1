Return-Path: <linux-kernel-owner+w=401wt.eu-S1765089AbZDCLvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765089AbZDCLvY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 07:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbZDCLvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 07:51:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45464 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755855AbZDCLvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 07:51:05 -0400
Message-ID: <49D5F80B.7000305@redhat.com>
Date: Fri, 03 Apr 2009 14:50:35 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Masami Hiramatsu <mhiramat@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Jim Keniston <jkenisto@us.ibm.com>,
       kvm@vger.kernel.org, systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip 0/6 V4] tracing: kprobe-based event tracer
References: <49D4F4B5.9040107@redhat.com> <20090403112639.GC31399@elte.hu>
In-Reply-To: <20090403112639.GC31399@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> ok, the structure and concept looks quite good now, really nice!
>
> I'm wondering about something i suggested many moons ago: to look 
> into the KVM decoder+emulator (arch/x86/kvm/x86_emulate.c).
>
> I remember there were some issues with that (one problem being that 
> the KVM decoder is a special-purpose thing covering specific range 
> of execution environments - not a near-full integer-ops decoder like 
> the one we are aiming for here) - are there any other fundamental 
> problems beyond 'it has to be done' ?
>
> Conceptually we want just a single piece of decoder logic in 
> arch/x86/. If the KVM folks are cool with it we could factor out the 
> KVM one into arch/x86/lib/. But ... if there are compelling reasons 
> to leave the KVM one alone in its limited environment we can do that 
> too.
>   

kvm has three requirements not needed by kprobes:
- it wants to execute instructions, not just decode them, including 
generating faults where appropriate
- it is performance critical
- it needs to support 16-bit, 32-bit, and 64-bit instructions simultaneously

If an arch/x86/ decoder/emulator gives me these I'll gladly switch to 
it.  x86_emulate.c is high on my list of most disliked code.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

