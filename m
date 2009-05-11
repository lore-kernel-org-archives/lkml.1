Return-Path: <linux-kernel-owner+w=401wt.eu-S1758019AbZEKPN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019AbZEKPN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758068AbZEKPM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:12:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36321 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758101AbZEKPM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:12:56 -0400
Message-ID: <4A0840DC.7080507@redhat.com>
Date: Mon, 11 May 2009 11:14:36 -0400
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
References: <20090509004829.5505.38720.stgit@localhost.localdomain> <20090509004847.5505.37957.stgit@localhost.localdomain> <alpine.DEB.2.00.0905111011060.14976@gandalf.stny.rr.com> <4A083DAD.8000009@redhat.com>
In-Reply-To: <4A083DAD.8000009@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
>>> +	if (!kallsyms_lookup(paddr, NULL, &offset, NULL, __dummy_buf))
>>> +		return 0;
>>> +
>>> +	/* Decode instructions */
>>> +	addr = paddr - offset;
>>> +	while (addr < paddr) {
>>> +		insn_init_kernel(&insn, (void *)addr);
>>> +		insn_get_opcode(&insn);
>>> +		if (OPCODE1(&insn) == BREAKPOINT_INSTRUCTION) {
>>> +			ret = recover_probed_instruction(buf, addr);
>> Oh, the above puts back the original op code. That is why it is OK?
> 
> Oops, no. I have to use get_kprobe() instead. Thanks!

Ah, I forgot another possibility. There might be another subsystem,
like kgdb, will put their break point on the kernel.
In that case, decoder will decode the instruction is a break point
instruction and the first opcode is int3. So, this part is correct.
In the future, we need to add a generic recover_instruction() code
for those text modification subsystems.

Thank you,
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

