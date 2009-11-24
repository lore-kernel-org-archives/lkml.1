Return-Path: <linux-kernel-owner+w=401wt.eu-S1757757AbZKXCvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757AbZKXCvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 21:51:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757602AbZKXCvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 21:51:15 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34781 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655AbZKXCvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 21:51:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=J64hiULPKYwJGj5mceMHvM94/DgGPerU8+yGVB/XPIueNhAgbgmJGBA8OXS8eQRaJb
         b7qMoTZDTJiG6VnrRut0g6Miy/k8/eS2xChlO1j1qiZ7R8v61XSw1tmKEQpX/UEMzYUw
         xhO5MEGhX049ditStuqSXB1BQsiq+fXFzZ+dY=
Date: Tue, 24 Nov 2009 03:51:17 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
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
Subject: Re: [PATCH -tip v5 06/10] kprobes/x86: Cleanup save/restore
	registers
Message-ID: <20091124025115.GB6752@nowhere>
References: <20091123232115.22071.71558.stgit@dhcp-100-2-132.bos.redhat.com> <20091123232204.22071.60562.stgit@dhcp-100-2-132.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123232204.22071.60562.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 06:22:04PM -0500, Masami Hiramatsu wrote:
> +#ifdef CONFIG_X86_64
> +#define SAVE_REGS_STRING		\
> +	/* Skip cs, ip, orig_ax. */	\
> +	"	subq $24, %rsp\n"	\
> +	"	pushq %rdi\n"		\
> +	"	pushq %rsi\n"		\
> +	"	pushq %rdx\n"		\
> +	"	pushq %rcx\n"		\
> +	"	pushq %rax\n"		\
> +	"	pushq %r8\n"		\
> +	"	pushq %r9\n"		\
> +	"	pushq %r10\n"		\
> +	"	pushq %r11\n"		\
> +	"	pushq %rbx\n"		\
> +	"	pushq %rbp\n"		\
> +	"	pushq %r12\n"		\
> +	"	pushq %r13\n"		\
> +	"	pushq %r14\n"		\
> +	"	pushq %r15\n"
> +#define RESTORE_REGS_STRING		\
> +	"	popq %r15\n"		\
> +	"	popq %r14\n"		\
> +	"	popq %r13\n"		\
> +	"	popq %r12\n"		\
> +	"	popq %rbp\n"		\
> +	"	popq %rbx\n"		\
> +	"	popq %r11\n"		\
> +	"	popq %r10\n"		\
> +	"	popq %r9\n"		\
> +	"	popq %r8\n"		\
> +	"	popq %rax\n"		\
> +	"	popq %rcx\n"		\
> +	"	popq %rdx\n"		\
> +	"	popq %rsi\n"		\
> +	"	popq %rdi\n"		\


BTW, do you really need to push/pop every registers
before/after calling a probe handler?

Is it possible to only save/restore the scratch ones?

