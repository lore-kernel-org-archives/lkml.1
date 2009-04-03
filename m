Return-Path: <linux-kernel-owner+w=401wt.eu-S1765586AbZDCOWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765586AbZDCOWO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:22:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbZDCOVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:21:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49397 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764724AbZDCOVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:21:54 -0400
Message-ID: <49D61B56.9020408@redhat.com>
Date: Fri, 03 Apr 2009 10:21:10 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Jim Keniston <jkenisto@us.ibm.com>,
       kvm@vger.kernel.org, systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH -tip 0/6 V4] tracing: kprobe-based event tracer
References: <49D4F4B5.9040107@redhat.com> <20090403112639.GC31399@elte.hu> <49D5F80B.7000305@redhat.com>
In-Reply-To: <49D5F80B.7000305@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Ingo Molnar wrote:
>> ok, the structure and concept looks quite good now, really nice!
>>
>> I'm wondering about something i suggested many moons ago: to look into
>> the KVM decoder+emulator (arch/x86/kvm/x86_emulate.c).
>>
>> I remember there were some issues with that (one problem being that
>> the KVM decoder is a special-purpose thing covering specific range of
>> execution environments - not a near-full integer-ops decoder like the
>> one we are aiming for here) - are there any other fundamental problems
>> beyond 'it has to be done' ?
>>
>> Conceptually we want just a single piece of decoder logic in
>> arch/x86/. If the KVM folks are cool with it we could factor out the
>> KVM one into arch/x86/lib/. But ... if there are compelling reasons to
>> leave the KVM one alone in its limited environment we can do that too.
>>   
> 
> kvm has three requirements not needed by kprobes:
> - it wants to execute instructions, not just decode them, including
> generating faults where appropriate
> - it is performance critical
> - it needs to support 16-bit, 32-bit, and 64-bit instructions
> simultaneously

Hmm, I'd like to know actually kvm aims to emulate all kinds of
instructions. If so, I might find some bugs in x86_emulate.c.
However, I don't know all bugs. To find all of them, we have to
port x86_emulate.c to user-space, decode binaries with it, and
compare its output with another decoder, as Jim had done with insn.c.

https://www.redhat.com/archives/utrace-devel/2009-March/msg00031.html


Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

