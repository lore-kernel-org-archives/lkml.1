Return-Path: <linux-kernel-owner+w=401wt.eu-S935999AbZDAX3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935999AbZDAX3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 19:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935493AbZDAXV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 19:21:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60038 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935492AbZDAXV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 19:21:58 -0400
Message-ID: <49D3F713.1000502@redhat.com>
Date: Wed, 01 Apr 2009 19:21:55 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [PATCH -tip 0/4 V3] tracing: kprobe-based event tracer
References: <49CC08A2.5030602@redhat.com> <20090401133654.GB18677@elte.hu> <49D37584.50208@redhat.com> <873acsm8qp.fsf@basil.nowhere.org> <49D3D3B4.4060702@redhat.com> <20090401221540.GX11935@one.firstfloor.org>
In-Reply-To: <20090401221540.GX11935@one.firstfloor.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Wed, Apr 01, 2009 at 04:51:00PM -0400, Masami Hiramatsu wrote:
>> Andi Kleen wrote:
>>> Masami Hiramatsu <mhiramat@redhat.com> writes:
>>>> I agreed. Fortunately, Jim Keniston and I wrote an x86 instruction
>>>> decoder :-) which has been made originally for uprobe andd kprobes
>>>> jump-optimizer.
>>>>
>>>> https://www.redhat.com/archives/utrace-devel/2009-March/msg00031.html
>>> An alternative would be to adapt the x86 interpreter in KVM.
>>> I thought for some time that that one should be available in 
>>> a more generic form in a library.
>> As far as I can see, KVM's instruction emulator is incomplete
> 
> That's fine for you -- you only care about a subset of instructions
> anyways, don't you?

Actually, (in my case) I just need to decode non-FPU instructions,
because I'd like to check whether kprobe is on the instruction
boundary.

However, KVM's insn decoder can't decode some elemental
instructions, and instruction flags are incorrect.
I had written instruction decoder based on it, but the result
was so awful!
So soon, I had to rewrite it based on Intel's manual entirely :-(


>> (it doesn't cover all instructions...) and aims to emulate
>> instructions, not to analyze (so I couldn't relay on it).
> 
> You can use it to analyze, just plug in the right callbacks that
> do nothing. I looked at it some time ago for doing instruction
> length checking for some application, but that application
> then disappeared. The main obstacle with making it a library 
> is that some KVM specific dependencies have crept in that would
> need to be abstracted again, but I don't think it would need a lot of 
> effort,

Sorry, but I don't think so. Current KVM's decoder is much more
focusing on preparing instructions emulation. It requires
vcpu setup, fetching operators and so on. I think it needs to
diet their code (or well splitting from emulator).

Anyway, I don't stick with my decoder. If they can provide more
generic interfaces, I'd be happy to use it. :-)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

