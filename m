Return-Path: <linux-kernel-owner+w=401wt.eu-S1764179AbZDCL1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764179AbZDCL1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 07:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761725AbZDCL1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 07:27:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46535 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758547AbZDCL1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 07:27:31 -0400
Date: Fri, 3 Apr 2009 13:26:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Avi Kivity <avi@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Jim Keniston <jkenisto@us.ibm.com>,
       kvm@vger.kernel.org, systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip 0/6 V4] tracing: kprobe-based event tracer
Message-ID: <20090403112639.GC31399@elte.hu>
References: <49D4F4B5.9040107@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D4F4B5.9040107@redhat.com>
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


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Hi,
> 
> Here are the patches of kprobe-based event tracer for x86, version 4.
> 
> This version supports only x86(-32/-64) (If someone is interested in
> porting this to other architectures, he just needs to port
> kprobes/kretprobes and ptrace enhancement[PATCH 2/6]).
> 
> I added x86 insn decoder on this version. It might be better
> integrated with KVM's decoder, and kprobes x86 code should be
> rewritten with it.
> 
> 
> This can be applied on the linux-2.6-tip tree.
> 
> This patchset includes following changes:
> - Fix kernel_trap_sp() on x86 according to systemtap runtime. [1/6]
> - Add arch-dep register and stack fetching functions [2/6]
> - Add x86 instruction decoder [3/6]
> - Check insertion point safety in kprobe [4/6]
> - Add kprobe-tracer plugin [5/6]
> - Support fetching various status (register/stack/memory/etc.) [6/6]

ok, the structure and concept looks quite good now, really nice!

I'm wondering about something i suggested many moons ago: to look 
into the KVM decoder+emulator (arch/x86/kvm/x86_emulate.c).

I remember there were some issues with that (one problem being that 
the KVM decoder is a special-purpose thing covering specific range 
of execution environments - not a near-full integer-ops decoder like 
the one we are aiming for here) - are there any other fundamental 
problems beyond 'it has to be done' ?

Conceptually we want just a single piece of decoder logic in 
arch/x86/. If the KVM folks are cool with it we could factor out the 
KVM one into arch/x86/lib/. But ... if there are compelling reasons 
to leave the KVM one alone in its limited environment we can do that 
too.

Avi, Peter, what's your take on this?

	Ingo
