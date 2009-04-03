Return-Path: <linux-kernel-owner+w=401wt.eu-S1759129AbZDCFTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129AbZDCFTZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 01:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbZDCFTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 01:19:14 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:35236 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbZDCFTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 01:19:14 -0400
Date: Fri, 3 Apr 2009 10:48:54 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jim Keniston <jkenisto@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>, kvm@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH -tip 4/6 V4] x86: kprobes checks safeness of insertion
	address.
Message-ID: <20090403051854.GA4846@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <49D4F4E9.2030809@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D4F4E9.2030809@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 01:24:57PM -0400, Masami Hiramatsu wrote:
 
> +/* Recover original instruction */
> +static int recover_probed_instruction(kprobe_opcode_t *buf, unsigned long addr)
> +{
> +	struct kprobe *kp;
> +	kp = get_kprobe((void *)addr);
> +	if (!kp)
> +		return -EINVAL;
> +
> +	/* Don't use p->ainsn.insn; which will be modified by fix_riprel */
> +	memcpy(buf, kp->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
> +	buf[0] = kp->opcode;
> +	return 0;
> +}
> +
> +/* Dummy buffers for lookup_symbol_attrs */
> +static char __dummy_buf[KSYM_NAME_LEN];
> +
> +/* Check whether the address can be probed */
> +static int __kprobes can_probe(unsigned long paddr)

A better description would've been "Check if paddr is at an instruction
boundary". Otherwise looks good.

Ananth
