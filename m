Return-Path: <linux-kernel-owner+w=401wt.eu-S1758153AbZKXPht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153AbZKXPht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758141AbZKXPhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:37:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758142AbZKXPhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:37:45 -0500
Message-ID: <4B0BFE21.7000102@redhat.com>
Date: Tue, 24 Nov 2009 10:39:13 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH -tip v5 06/10] kprobes/x86: Cleanup save/restore	registers
References: <20091123232115.22071.71558.stgit@dhcp-100-2-132.bos.redhat.com> <20091123232204.22071.60562.stgit@dhcp-100-2-132.bos.redhat.com> <20091124025115.GB6752@nowhere>
In-Reply-To: <20091124025115.GB6752@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Mon, Nov 23, 2009 at 06:22:04PM -0500, Masami Hiramatsu wrote:
>> +#ifdef CONFIG_X86_64
>> +#define SAVE_REGS_STRING		\
>> +	/* Skip cs, ip, orig_ax. */	\
>> +	"	subq $24, %rsp\n"	\
>> +	"	pushq %rdi\n"		\
>> +	"	pushq %rsi\n"		\
>> +	"	pushq %rdx\n"		\
>> +	"	pushq %rcx\n"		\
>> +	"	pushq %rax\n"		\
>> +	"	pushq %r8\n"		\
>> +	"	pushq %r9\n"		\
>> +	"	pushq %r10\n"		\
>> +	"	pushq %r11\n"		\
>> +	"	pushq %rbx\n"		\
>> +	"	pushq %rbp\n"		\
>> +	"	pushq %r12\n"		\
>> +	"	pushq %r13\n"		\
>> +	"	pushq %r14\n"		\
>> +	"	pushq %r15\n"
>> +#define RESTORE_REGS_STRING		\
>> +	"	popq %r15\n"		\
>> +	"	popq %r14\n"		\
>> +	"	popq %r13\n"		\
>> +	"	popq %r12\n"		\
>> +	"	popq %rbp\n"		\
>> +	"	popq %rbx\n"		\
>> +	"	popq %r11\n"		\
>> +	"	popq %r10\n"		\
>> +	"	popq %r9\n"		\
>> +	"	popq %r8\n"		\
>> +	"	popq %rax\n"		\
>> +	"	popq %rcx\n"		\
>> +	"	popq %rdx\n"		\
>> +	"	popq %rsi\n"		\
>> +	"	popq %rdi\n"		\
> 
> 
> BTW, do you really need to push/pop every registers
> before/after calling a probe handler?

Yes, in both cases (kretprobe/optprpbe) it needs to
emulate kprobes behavior. kprobes can be used as
fault injection, it should pop pt_regs.

> Is it possible to only save/restore the scratch ones?

Hmm, what code did you mean?

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

