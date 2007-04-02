Return-Path: <linux-kernel-owner+w=401wt.eu-S933575AbXDBGBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933575AbXDBGBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 02:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933740AbXDBGBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 02:01:03 -0400
Received: from smtp.osdl.org ([65.172.181.24]:37132 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933631AbXDBGAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 02:00:47 -0400
Date: Sun, 1 Apr 2007 23:00:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/16] warn-on-kthread-name-truncation.diff
Message-Id: <20070401230041.adb1647a.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.61.0704012011430.12316@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0704012011430.12316@yvahk01.tjqt.qr>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Apr 2007 20:18:22 +0200 (MEST) Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:

> Andrew Morton noted in http://lkml.org/lkml/2006/6/30/247
> 
> 	"""We do occasionally hit task_struct.comm[] truncation, when people
> 	use "too-long-a-name%d" for their kernel thread names."""
> 
> This patch warns when such a truncation happens.
> 
> Already posted on http://lkml.org/lkml/2006/7/3/93
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> 
>  kthread.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.21-rc5/kernel/kthread.c
> ===================================================================
> --- linux-2.6.21-rc5.orig/kernel/kthread.c
> +++ linux-2.6.21-rc5/kernel/kthread.c
> @@ -176,8 +176,11 @@ struct task_struct *kthread_create(int (
>  	if (!IS_ERR(create.result)) {
>  		va_list args;
>  		va_start(args, namefmt);
> -		vsnprintf(create.result->comm, sizeof(create.result->comm),
> -			  namefmt, args);
> +		if(vsnprintf(create.result->comm, sizeof(create.result->comm),
> +		  namefmt, args) != strlen(create.result->comm))
> +			printk(KERN_WARNING "kthread_create: command name of "
> +			  "pid %d truncated to \"%s\"\n", create.result->pid,
> +			  create.result->comm);
>  		va_end(args);
>  	}

I'm not sure that it's a big enough problem to go adding code for, really.
