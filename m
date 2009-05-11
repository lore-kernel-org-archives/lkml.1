Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbZEKPWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbZEKPWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbZEKPWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:22:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52371 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbZEKPWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:22:21 -0400
Date: Mon, 11 May 2009 11:22:19 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Masami Hiramatsu <mhiramat@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [PATCH -tip v5 2/7] kprobes: checks probe address is instruction
 boudary on x86
In-Reply-To: <4A083DAD.8000009@redhat.com>
Message-ID: <alpine.DEB.2.00.0905111119390.2492@gandalf.stny.rr.com>
References: <20090509004829.5505.38720.stgit@localhost.localdomain> <20090509004847.5505.37957.stgit@localhost.localdomain> <alpine.DEB.2.00.0905111011060.14976@gandalf.stny.rr.com> <4A083DAD.8000009@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 11 May 2009, Masami Hiramatsu wrote:
> 
> > 
> >> +	 * by fix_riprel().
> >> +	 */
> >> +	memcpy(buf, kp->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
> >> +	buf[0] = kp->opcode;
> > 
> > Why is it OK to copy addr to "buf" and then rewrite the first character of 
> > buf?  Does it have something to do with the above "p"?
> 
> Yes, each kprobe copied probed instruction to kp->ainsn.insn,
> which is an executable buffer for single stepping.
> So, basically, kp->ainsn.insn has an original instruction.
> However, RIP-relative instruction can not do single-stepping
> at different place, fix_riprel() tweaks the displacement of
> that instruction. In that case, we can't recover the instruction
> from the kp->ainsn.insn.
> 
> On the other hand, kp->opcode has a copy of the first byte of
> the probed instruction, which is overwritten by int3. And
> the instruction at kp->addr is not modified by kprobes except
> for the first byte, we can recover the original instruction
> from it and kp->opcode.

For code that is awkward, complex or non-trivial, don't be afraid to put 
in a paragraph explaining the code. The above explanation should be a 
comment in the code. Otherwise people like me would just look at it and 
say "huh?".

Note, I'm a bit cranky this morning, so I hope I don't offend anyone.

-- Steve
