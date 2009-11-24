Return-Path: <linux-kernel-owner+w=401wt.eu-S932748AbZKXUTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748AbZKXUTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 15:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932471AbZKXUTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 15:19:21 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:31574 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245AbZKXUTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 15:19:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dYCrIySjpf3WGtQ75J6edL0d3KHci4bxM82A2di3CfJ6mxac7GCVvsK3ZDMMI7OguZ
         s4C34kNofT0obAeSePxzO7PNO928L5Ei/80vmhQXjwAIK1/gO3R0u6rT3/zNqN4XSohD
         dVNRZMSrjgtJKAII7MbOEfhECkyfR/5DjASks=
Date: Tue, 24 Nov 2009 21:19:22 +0100
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
Message-ID: <20091124201919.GC5071@nowhere>
References: <20091123232115.22071.71558.stgit@dhcp-100-2-132.bos.redhat.com> <20091123232204.22071.60562.stgit@dhcp-100-2-132.bos.redhat.com> <20091124025115.GB6752@nowhere> <4B0BFE21.7000102@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0BFE21.7000102@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 10:39:13AM -0500, Masami Hiramatsu wrote:
> Frederic Weisbecker wrote:
> > On Mon, Nov 23, 2009 at 06:22:04PM -0500, Masami Hiramatsu wrote:
> >> +#ifdef CONFIG_X86_64
> >> +#define SAVE_REGS_STRING		\
> >> +	/* Skip cs, ip, orig_ax. */	\
> >> +	"	subq $24, %rsp\n"	\
> >> +	"	pushq %rdi\n"		\
> >> +	"	pushq %rsi\n"		\
> >> +	"	pushq %rdx\n"		\
> >> +	"	pushq %rcx\n"		\
> >> +	"	pushq %rax\n"		\
> >> +	"	pushq %r8\n"		\
> >> +	"	pushq %r9\n"		\
> >> +	"	pushq %r10\n"		\
> >> +	"	pushq %r11\n"		\
> >> +	"	pushq %rbx\n"		\
> >> +	"	pushq %rbp\n"		\
> >> +	"	pushq %r12\n"		\
> >> +	"	pushq %r13\n"		\
> >> +	"	pushq %r14\n"		\
> >> +	"	pushq %r15\n"
> >> +#define RESTORE_REGS_STRING		\
> >> +	"	popq %r15\n"		\
> >> +	"	popq %r14\n"		\
> >> +	"	popq %r13\n"		\
> >> +	"	popq %r12\n"		\
> >> +	"	popq %rbp\n"		\
> >> +	"	popq %rbx\n"		\
> >> +	"	popq %r11\n"		\
> >> +	"	popq %r10\n"		\
> >> +	"	popq %r9\n"		\
> >> +	"	popq %r8\n"		\
> >> +	"	popq %rax\n"		\
> >> +	"	popq %rcx\n"		\
> >> +	"	popq %rdx\n"		\
> >> +	"	popq %rsi\n"		\
> >> +	"	popq %rdi\n"		\
> > 
> > 
> > BTW, do you really need to push/pop every registers
> > before/after calling a probe handler?
> 
> Yes, in both cases (kretprobe/optprpbe) it needs to
> emulate kprobes behavior. kprobes can be used as
> fault injection, it should pop pt_regs.
> 
> > Is it possible to only save/restore the scratch ones?
> 
> Hmm, what code did you mean?



Ah this chain of push/pop is there to dump a struct pt_regs for
the handler?
Sorry, I just thought it was to save the registers from the probed
function.

