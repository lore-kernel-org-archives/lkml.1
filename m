Return-Path: <linux-kernel-owner+w=401wt.eu-S1758256AbZEKSUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256AbZEKSUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 14:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755657AbZEKSUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 14:20:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38013 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232AbZEKSUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 14:20:20 -0400
Message-ID: <4A086CA4.4030302@redhat.com>
Date: Mon, 11 May 2009 14:21:24 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [PATCH -tip v5 2/7] kprobes: checks probe address is instruction
 boudary on x86
References: <20090509004829.5505.38720.stgit@localhost.localdomain> <20090509004847.5505.37957.stgit@localhost.localdomain> <alpine.DEB.2.00.0905111011060.14976@gandalf.stny.rr.com> <4A083DAD.8000009@redhat.com> <alpine.DEB.2.00.0905111119390.2492@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0905111119390.2492@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Mon, 11 May 2009, Masami Hiramatsu wrote:
>>>> +	 * by fix_riprel().
>>>> +	 */
>>>> +	memcpy(buf, kp->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
>>>> +	buf[0] = kp->opcode;
>>> Why is it OK to copy addr to "buf" and then rewrite the first character of 
>>> buf?  Does it have something to do with the above "p"?
>> Yes, each kprobe copied probed instruction to kp->ainsn.insn,
>> which is an executable buffer for single stepping.
>> So, basically, kp->ainsn.insn has an original instruction.
>> However, RIP-relative instruction can not do single-stepping
>> at different place, fix_riprel() tweaks the displacement of
>> that instruction. In that case, we can't recover the instruction
>> from the kp->ainsn.insn.
>>
>> On the other hand, kp->opcode has a copy of the first byte of
>> the probed instruction, which is overwritten by int3. And
>> the instruction at kp->addr is not modified by kprobes except
>> for the first byte, we can recover the original instruction
>> from it and kp->opcode.
> 
> For code that is awkward, complex or non-trivial, don't be afraid to put 
> in a paragraph explaining the code. The above explanation should be a 
> comment in the code. Otherwise people like me would just look at it and 
> say "huh?".
> 
> Note, I'm a bit cranky this morning, so I hope I don't offend anyone.

No, that's very helpful review for me. Thanks :-)


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

