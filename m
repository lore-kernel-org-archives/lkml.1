Return-Path: <linux-kernel-owner+w=401wt.eu-S1759131AbYAPEwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759131AbYAPEwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 23:52:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756935AbYAPEv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 23:51:57 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:34676 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756795AbYAPEv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 23:51:56 -0500
Date: Wed, 16 Jan 2008 10:22:16 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Stephen Hemminger <stephen.hemminger@vyatta.com>
Cc: prasanna@in.ibm.com, anil.s.keshavamurthy@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kprobe: missing cast
Message-ID: <20080116045216.GA6804@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20080114192155.2d6982ea@speedy>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080114192155.2d6982ea@speedy>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 07:21:55PM -0800, Stephen Hemminger wrote:
> Fix warning from missing cast, maybe a result of the x86 merge?
> 
> Signed-off-by: Stephen Hemminger <stephen.hemminger@vyatta.com>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Thanks Stephen!

Ananth

> 
>   CC      arch/x86/kernel/kprobes_32.o
> arch/x86/kernel/kprobes_32.c: In function ‘longjmp_break_handler’:
> arch/x86/kernel/kprobes_32.c:729: warning: comparison of distinct pointer types lacks a cast
> 
> --- a/arch/x86/kernel/kprobes_32.c	2008-01-14 19:18:01.000000000 -0800
> +++ b/arch/x86/kernel/kprobes_32.c	2008-01-14 19:18:08.000000000 -0800
> @@ -726,7 +726,7 @@ int __kprobes longjmp_break_handler(stru
>  	struct jprobe *jp = container_of(p, struct jprobe, kp);
>  
>  	if ((addr > (u8 *) jprobe_return) && (addr < (u8 *) jprobe_return_end)) {
> -		if (&regs->esp != kcb->jprobe_saved_esp) {
> +		if ((unsigned long *) &regs->esp != kcb->jprobe_saved_esp) {
>  			struct pt_regs *saved_regs = &kcb->jprobe_saved_regs;
>  			printk("current esp %p does not match saved esp %p\n",
>  			       &regs->esp, kcb->jprobe_saved_esp);
