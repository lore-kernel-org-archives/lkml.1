Return-Path: <linux-kernel-owner+w=401wt.eu-S1765843AbZDCOYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765843AbZDCOYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761398AbZDCOYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:24:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33926 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758387AbZDCOYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:24:13 -0400
Date: Fri, 3 Apr 2009 16:23:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Jim Keniston <jkenisto@us.ibm.com>,
       kvm@vger.kernel.org, systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH -tip 0/6 V4] tracing: kprobe-based event tracer
Message-ID: <20090403142325.GA14932@elte.hu>
References: <49D4F4B5.9040107@redhat.com> <20090403112639.GC31399@elte.hu> <49D5F80B.7000305@redhat.com> <49D61B56.9020408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D61B56.9020408@redhat.com>
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

> Hmm, I'd like to know actually kvm aims to emulate all kinds of 
> instructions. If so, I might find some bugs in x86_emulate.c. 
> However, I don't know all bugs. To find all of them, we have to 
> port x86_emulate.c to user-space, decode binaries with it, and 
> compare its output with another decoder, as Jim had done with 
> insn.c.
> 
> https://www.redhat.com/archives/utrace-devel/2009-March/msg00031.html

btw., i'd suggest we put a build time check for this into the kernel 
version as well. For example to decode the vmlinux via objdump, run 
it through your decoder as well and compare the results. Put under a 
CONFIG_DEBUG_X86_DECODER_TEST kind of (deault-off) build-time 
self-test.

This would ensure that the kernel we are running is fully supported 
by the decoder - even as GCC/GAS starts using new instructions, etc. 

How does this sound to you?

	Ingo
