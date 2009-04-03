Return-Path: <linux-kernel-owner+w=401wt.eu-S1764304AbZDCMSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764304AbZDCMSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 08:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760375AbZDCMRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 08:17:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57050 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757918AbZDCMRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 08:17:48 -0400
Message-ID: <49D5FE42.5080100@redhat.com>
Date: Fri, 03 Apr 2009 15:17:06 +0300
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
References: <49D4F4B5.9040107@redhat.com> <20090403112639.GC31399@elte.hu> <49D5F80B.7000305@redhat.com> <20090403121202.GI31399@elte.hu>
In-Reply-To: <20090403121202.GI31399@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> kvm has three requirements not needed by kprobes:
>> - it wants to execute instructions, not just decode them, including  
>>   generating faults where appropriate
>> - it is performance critical
>> - it needs to support 16-bit, 32-bit, and 64-bit instructions simultaneously
>>
>> If an arch/x86/ decoder/emulator gives me these I'll gladly switch 
>> to it.  x86_emulate.c is high on my list of most disliked code.
>>     
>
> Well, this has to be driven from the KVM side as the kprobes use 
> will only be for decoding so if it's modified from the kprobes side 
> the KVM-only functionality might regress.
>
> So ... we can do the library decoder for kprobes purposes, and 
> someone versed in the KVM emulator can then combine the two.
>   

Problem is, anyone versed in the kvm emulator will want to run as far 
away from this work as possible.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

