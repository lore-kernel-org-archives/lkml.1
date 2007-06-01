Return-Path: <linux-kernel-owner+w=401wt.eu-S1761057AbXFAACS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761057AbXFAACS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 20:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755215AbXFAACI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 20:02:08 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756780AbXFAACG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 20:02:06 -0400
Date: Thu, 31 May 2007 17:02:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] console: console handover to preferred console
Message-Id: <20070531170200.3738f834.akpm@linux-foundation.org>
In-Reply-To: <200705311358.26559.yinghai.lu@sun.com>
References: <200705311358.26559.yinghai.lu@sun.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007 13:58:26 -0700
Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> [PATCH 2/5] console: console handover to preferred console
> 
> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
> 
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 0bbdeac..7b96cae 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -985,12 +1007,15 @@ void register_console(struct console *console)
>  	if (!(console->flags & CON_ENABLED))
>  		return;
>  
> -	if (bootconsole) {
> +	if (bootconsole && (console->flags & CON_CONSDEV)) {
>  		printk(KERN_INFO "console handover: boot [%s%d] -> real [%s%d]\n",
>  		       bootconsole->name, bootconsole->index,
>  		       console->name, console->index);
>  		unregister_console(bootconsole);
>  		console->flags &= ~CON_PRINTBUFFER;
> +	} else {
> +		printk(KERN_INFO "console [%s%d] enabled\n",
> +		       console->name, console->index);
>  	}
>  
>  	/*

What does this change do, and what is the reason for it??
