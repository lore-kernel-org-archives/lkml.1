Return-Path: <linux-kernel-owner+w=401wt.eu-S1760766AbXIRQmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760766AbXIRQmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 12:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759628AbXIRQm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 12:42:29 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39384 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758626AbXIRQm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 12:42:28 -0400
Date: Tue, 18 Sep 2007 22:12:24 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net
Subject: Re: [patch 09/11] Text Edit Lock - kprobes x86_64
Message-ID: <20070918164224.GB14594@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20070917184031.211525416@polymtl.ca> <20070917184210.769833022@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917184210.769833022@polymtl.ca>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 02:40:40PM -0400, Mathieu Desnoyers wrote:
> Make kprobes use text_set instead of text_poke.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Tested-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

> CC: Andi Kleen <andi@firstfloor.org>
> CC: prasanna@in.ibm.com
> CC: ananth@in.ibm.com
> CC: anil.s.keshavamurthy@intel.com
> CC: davem@davemloft.net
> ---
>  arch/x86_64/kernel/kprobes.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6-lttng/arch/x86_64/kernel/kprobes.c
> ===================================================================
> --- linux-2.6-lttng.orig/arch/x86_64/kernel/kprobes.c	2007-09-11 15:22:35.000000000 -0400
> +++ linux-2.6-lttng/arch/x86_64/kernel/kprobes.c	2007-09-11 15:49:51.000000000 -0400
> @@ -216,12 +216,13 @@ static void __kprobes arch_copy_kprobe(s
> 
>  void __kprobes arch_arm_kprobe(struct kprobe *p)
>  {
> -	text_poke(p->addr, ((unsigned char []){BREAKPOINT_INSTRUCTION}), 1);
> +	text_poke(p->addr, INIT_ARRAY(unsigned char, BREAKPOINT_INSTRUCTION, 1),
> +			1);
>  }
> 
>  void __kprobes arch_disarm_kprobe(struct kprobe *p)
>  {
> -	text_poke(p->addr, &p->opcode, 1);
> +	text_poke(p->addr, INIT_ARRAY(unsigned char, p->opcode, 1), 1);
>  }
> 
>  void __kprobes arch_remove_kprobe(struct kprobe *p)
> 
> -- 
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
