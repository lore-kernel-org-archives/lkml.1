Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbYGWUNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbYGWUNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 16:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbYGWUN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 16:13:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752675AbYGWUN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 16:13:29 -0400
Date: Wed, 23 Jul 2008 13:12:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, andi@firstfloor.org,
       arjan@infradead.org, ebiederm@xmission.com, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: usb debug port early console
Message-Id: <20080723131218.f03ed672.akpm@linux-foundation.org>
In-Reply-To: <200807231252.20371.yhlu.kernel@gmail.com>
References: <200807231252.20371.yhlu.kernel@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2008 12:52:20 -0700
Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> 
> 
> based on work from Eric, and add some timeout so don't dead loop when debug device
> is not installed
> 
>
> ...
>
> +static void dbgp_mdelay(int ms)
> +{
> +	int i;
> +	while (ms--) {
> +		for (i = 0; i < 1000; i++)
> +			outb(0x1, 0x80);
> +	}
> +}

hm.  port 80 has a guaranteed one microsecond?  Why not
udelay()/mdelay()/etc?

> +static void dbgp_breath(void)
> +{
> +	/* Sleep to give the debug port a chance to breathe */
> +}

I expect the compiler will optimise away any calls to this.

>
> ...
>
> --- linux-2.6.orig/arch/x86/kernel/head64.c
> +++ linux-2.6/arch/x86/kernel/head64.c
> @@ -72,6 +72,8 @@ static void __init copy_bootdata(char *r
>  	}
>  }
>  
> +extern void __init enable_debug_console(char *buf);

Please always pass all patches through scripts/checkpatch.pl.

