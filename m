Return-Path: <linux-kernel-owner+w=401wt.eu-S1760959AbYCUTDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959AbYCUTDW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 15:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755977AbYCUTDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 15:03:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43450 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708AbYCUTDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 15:03:11 -0400
Date: Fri, 21 Mar 2008 20:02:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: David Miller <davem@davemloft.net>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [11/14] vcompound: Fallbacks for order 1 stack allocations on
	IA64 and x86
Message-ID: <20080321190258.GF6571@elte.hu>
References: <20080321061703.921169367@sgi.com> <20080321061726.782068299@sgi.com> <20080321.002502.223136918.davem@davemloft.net> <20080321083952.GA20454@elte.hu> <Pine.LNX.4.64.0803211032390.18671@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803211032390.18671@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Christoph Lameter <clameter@sgi.com> wrote:

> On Fri, 21 Mar 2008, Ingo Molnar wrote:
> 
> > another thing is that this patchset includes KERNEL_STACK_SIZE_ORDER 
> > which has been NACK-ed before on x86 by several people and i'm 
> > nacking this "configurable stack size" aspect of it again.
> 
> Huh? Nothing of that nature is in this patchset.

your patch indeed does not introduce it here, but 
KERNEL_STACK_SIZE_ORDER shows up in the x86 portion of your patch and 
you refer to multi-order stack allocations in your 0/14 mail :-)

> -#define alloc_task_struct()	((struct task_struct *)__get_free_pages(GFP_KERNEL | __GFP_COMP, KERNEL_STACK_SIZE_ORDER))
> -#define free_task_struct(tsk)	free_pages((unsigned long) (tsk), KERNEL_STACK_SIZE_ORDER)
> +#define alloc_task_struct()	((struct task_struct *)__alloc_vcompound( \
> +			GFP_KERNEL, KERNEL_STACK_SIZE_ORDER))

	Ingo
