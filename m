Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbZIKBnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbZIKBnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 21:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbZIKBnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 21:43:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33413 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbZIKBnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 21:43:06 -0400
Subject: Re: [PATCH tracing/kprobes 1/7] x86/ptrace: Fix
 regs_get_argument_nth() to add correct offset
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>
In-Reply-To: <20090910235306.22412.31613.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com>
	 <20090910235306.22412.31613.stgit@dhcp-100-2-132.bos.redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 10 Sep 2009 21:43:06 -0400
Message-Id: <1252633386.18996.60.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-10 at 19:53 -0400, Masami Hiramatsu wrote:

> ---
> 
>  arch/x86/kernel/ptrace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
> index a33a17d..caffb68 100644
> --- a/arch/x86/kernel/ptrace.c
> +++ b/arch/x86/kernel/ptrace.c
> @@ -150,7 +150,7 @@ static const int arg_offs_table[] = {
>  unsigned long regs_get_argument_nth(struct pt_regs *regs, unsigned int n)
>  {
>  	if (n < ARRAY_SIZE(arg_offs_table))
> -		return *((unsigned long *)regs + arg_offs_table[n]);
> +		return *(unsigned long *)((char *)regs + arg_offs_table[n]);

That definitely looks like a bug.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

>  	else {
>  		/*
>  		 * The typical case: arg n is on the stack.
> 
> 

