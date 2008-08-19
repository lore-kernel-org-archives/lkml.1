Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbYHSODe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbYHSODe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 10:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbYHSOD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 10:03:26 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:47521 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbYHSOD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 10:03:26 -0400
Date: Tue, 19 Aug 2008 19:31:53 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Srinivasa DS <srinivasa@in.ibm.com>, Jim Keniston <jkenisto@us.ibm.com>,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       mhiramat@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make kprobes.c:kretprobe_table_lock() static
Message-ID: <20080819140153.GA3836@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20080819134706.GF8852@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819134706.GF8852@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 04:47:06PM +0300, Adrian Bunk wrote:
> This patch makes the needlessly global kretprobe_table_lock() static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Thanks Adrian.

> ---
> 7282c07a74451fca15cad3b8b1626e0b9ec0ba17 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 75bc2cd..8b57a25 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -404,7 +404,7 @@ void kretprobe_hash_lock(struct task_struct *tsk,
>  	spin_lock_irqsave(hlist_lock, *flags);
>  }
> 
> -void kretprobe_table_lock(unsigned long hash, unsigned long *flags)
> +static void kretprobe_table_lock(unsigned long hash, unsigned long *flags)
>  {
>  	spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
>  	spin_lock_irqsave(hlist_lock, *flags);
