Return-Path: <linux-kernel-owner+w=401wt.eu-S1757585AbZKCCjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585AbZKCCjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 21:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756168AbZKCCjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 21:39:20 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:43871 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162AbZKCCjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 21:39:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cciExpk88+q7k9pdJFp1XajybiTcMvNMpt1dUiXsk4jQwmIQ+g7QpCHh+YQ2QGYbKp
         pzxoWb10e3bD4MwkXrTWm6FhuXYH6G1Io63A0of+Ov8xV2K7jlsLNpyTxJvzd1fujjKb
         oifVowFmmu9PCsZKfasUSQsLzNOzs9eNiDidM=
Date: Tue, 3 Nov 2009 10:39:41 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86: Make sure we also print a Code: line for
	show_regs()
Message-ID: <20091103023941.GA2460@hack.redhat.com>
References: <20091102165915.4a980fc0@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091102165915.4a980fc0@infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 04:59:15PM -0800, Arjan van de Ven wrote:
>From c560acdd03d28d3dc55ed9c19d42d4567caab1d8 Mon Sep 17 00:00:00 2001
>From: Arjan van de Ven <arjan@linux.intel.com>
>Date: Mon, 2 Nov 2009 16:50:04 -0800
>Subject: [PATCH] x86: Make sure we also print a Code: line for show_regs()
>
>show_regs() is called as a mini BUG() equivalent in some places,
>specifically for the "scheduling while atomic" case.
>
>Unfortunately right now it does not print a Code: like unlike
>a real bug/oops.
>
>This patch changes the x86 implementation of show_regs() so that
>it calls the same function as oopses do to print the registers
>as well as the Code: line.
>
>Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

>---
> arch/x86/kernel/process_32.c |    2 +-
> arch/x86/kernel/process_64.c |    3 +--
> 2 files changed, 2 insertions(+), 3 deletions(-)
>
>diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
>index f2cb086..b124f2f 100644
>--- a/arch/x86/kernel/process_32.c
>+++ b/arch/x86/kernel/process_32.c
>@@ -189,7 +189,7 @@ void __show_regs(struct pt_regs *regs, int all)
> 
> void show_regs(struct pt_regs *regs)
> {
>-	__show_regs(regs, 1);
>+	show_registers(regs);
> 	show_trace(NULL, regs, &regs->sp, regs->bp);
> }
> 
>diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
>index 959b062..e53e66f 100644
>--- a/arch/x86/kernel/process_64.c
>+++ b/arch/x86/kernel/process_64.c
>@@ -228,8 +228,7 @@ void __show_regs(struct pt_regs *regs, int all)
> 
> void show_regs(struct pt_regs *regs)
> {
>-	printk(KERN_INFO "CPU %d:", smp_processor_id());
>-	__show_regs(regs, 1);
>+	show_registers(regs);
> 	show_trace(NULL, regs, (void *)(regs + 1), regs->bp);
> }
> 
>-- 
>1.6.0.6
>
>
>
>-- 
>Arjan van de Ven 	Intel Open Source Technology Centre
>For development, discussion and tips for power savings, 
>visit http://www.lesswatts.org
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Live like a child, think like the god.
 
