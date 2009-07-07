Return-Path: <linux-kernel-owner+w=401wt.eu-S1758220AbZGGVEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220AbZGGVEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 17:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755900AbZGGVER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 17:04:17 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:57691 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378AbZGGVER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 17:04:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PMlla91K5LosjmLmVB1sKokyrGxkb3m97TAQ3M3vMcvc9zkTAFQvS7EWv4J4FWB6zN
         rCWr9QMZrUVqAIvdUHsHtOLqr4Irits4KKzWy6VdnGmIvs+BOAn+4HLOl1rrBFlqasoE
         a14B8mOyvfneXf53qIaptUstCxwhC9sY6BZJM=
Date: Tue, 7 Jul 2009 23:04:12 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Stern <stern@rowland.harvard.edu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hw_breakpoint: remove sample code from hw_breakpoint.h
Message-ID: <20090707210410.GG6184@nowhere>
References: <4A52DFBB.7040800@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A52DFBB.7040800@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 01:40:11PM +0800, Li Zefan wrote:
> The sample code is a bit out-dated, and there's already a
> sample in sample/hw_breakpoint/.


IMHO these bits of comments are useful and don't overlap the role
of the samples in sample/
They only stand there as a quick summup.

No?

 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  include/asm-generic/hw_breakpoint.h |   41 +---------------------------------
>  1 files changed, 2 insertions(+), 39 deletions(-)
> 
> diff --git a/include/asm-generic/hw_breakpoint.h b/include/asm-generic/hw_breakpoint.h
> index 9bf2d12..30ab37c 100644
> --- a/include/asm-generic/hw_breakpoint.h
> +++ b/include/asm-generic/hw_breakpoint.h
> @@ -60,45 +60,8 @@
>   * Breakpoints are disabled during execution @triggered, to avoid
>   * recursive traps and allow unhindered access to breakpointed memory.
>   *
> - * This sample code sets a breakpoint on pid_max and registers a callback
> - * function for writes to that variable.  Note that it is not portable
> - * as written, because not all architectures support HW_BREAKPOINT_LEN_4.
> - *
> - * ----------------------------------------------------------------------
> - *
> - * #include <asm/hw_breakpoint.h>
> - *
> - * struct hw_breakpoint my_bp;
> - *
> - * static void my_triggered(struct hw_breakpoint *bp, struct pt_regs *regs)
> - * {
> - * 	printk(KERN_DEBUG "Inside triggered routine of breakpoint exception\n");
> - * 	dump_stack();
> - *  	.......<more debugging output>........
> - * }
> - *
> - * static struct hw_breakpoint my_bp;
> - *
> - * static int init_module(void)
> - * {
> - *	..........<do anything>............
> - *	my_bp.info.type = HW_BREAKPOINT_WRITE;
> - *	my_bp.info.len = HW_BREAKPOINT_LEN_4;
> - *
> - *	my_bp.installed = (void *)my_bp_installed;
> - *
> - *	rc = register_kernel_hw_breakpoint(&my_bp);
> - *	..........<do anything>............
> - * }
> - *
> - * static void cleanup_module(void)
> - * {
> - *	..........<do anything>............
> - *	unregister_kernel_hw_breakpoint(&my_bp);
> - *	..........<do anything>............
> - * }
> - *
> - * ----------------------------------------------------------------------
> + * See sample/hw_breakpoint/ for a sample that sets a breakpoint on
> + * a specified kernel symbol.
>   */
>  struct hw_breakpoint {
>  	void (*triggered)(struct hw_breakpoint *, struct pt_regs *);
> -- 
> 1.5.4.rc3

