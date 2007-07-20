Return-Path: <linux-kernel-owner+w=401wt.eu-S932897AbXGTVGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932897AbXGTVGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758944AbXGTVGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:06:37 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46214 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759317AbXGTVGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:06:37 -0400
Date: Fri, 20 Jul 2007 14:06:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konrad Rzeszutek <konrad@darnok.org>
Cc: darnok@68k.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Inhibit NMI watchdog when Alt-SysRq-T operation is
 underway.
Message-Id: <20070720140620.e742a2b9.akpm@linux-foundation.org>
In-Reply-To: <20070720111823.GA2334@andromeda.dapyr.net>
References: <20070709140242.GA18098@andromeda.dapyr.net>
	<20070709155302.GB26570@andromeda.dapyr.net>
	<20070713164504.66b72e74.akpm@linux-foundation.org>
	<20070720111823.GA2334@andromeda.dapyr.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007 07:18:23 -0400
Konrad Rzeszutek <konrad@darnok.org> wrote:

> I tested your patch along with mine and found two things out:
> 
>  1). Missing this patch (for i386 platform)
> 
> diff --git a/arch/i386/kernel/traps.c b/arch/i386/kernel/traps.c
> index 90da057..9f3a7ff 100644
> --- a/arch/i386/kernel/traps.c
> +++ b/arch/i386/kernel/traps.c
> @@ -207,6 +207,7 @@ static void print_trace_address(void *da
>  {
>  	printk("%s [<%08lx>] ", (char *)data, addr);
>  	print_symbol("%s\n", addr);
> +	touch_nmi_watchdog();
>  }

ok...

>  static struct stacktrace_ops print_trace_ops = {
> 
> 
>   2). If I run Alt-SysRq-t about 5000 times in a loop, the slow down 
>       with this change is about 5%. Is this a big issue? (This was
>       testing both i686 and x86_64).
> 

I'm surprised.  I assume this was when it was printing to a high-speed
device?  console or netconsole?

I don't think we need to spend too much time optimising sysrq-T performance ;)
