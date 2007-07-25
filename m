Return-Path: <linux-kernel-owner+w=401wt.eu-S932418AbXGYBh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418AbXGYBh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 21:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932362AbXGYBg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 21:36:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45785 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932323AbXGYBgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 21:36:55 -0400
Date: Tue, 24 Jul 2007 18:36:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] Fix arch/i386/kernel/nmi.c -
 'unknown_nmi_panic_callback' declared 'static' but never defined warning
Message-Id: <20070724183636.63844865.akpm@linux-foundation.org>
In-Reply-To: <46A3AE06.9030706@googlemail.com>
References: <46A3AE06.9030706@googlemail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jul 2007 21:20:38 +0200 Gabriel C <nix.or.die@googlemail.com> wrote:

> I get this warning when CONFIG_SYSCTL is not set :
> 
> ...
> 
> arch/i386/kernel/nmi.c:52: warning: 'unknown_nmi_panic_callback' declared 'static' but never defined
> 
> ...
> 
> Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
> 
> ---
> 
> diff --git a/arch/i386/kernel/nmi.c b/arch/i386/kernel/nmi.c
> index 03b7f55..cf11121 100644
> --- a/arch/i386/kernel/nmi.c
> +++ b/arch/i386/kernel/nmi.c
> @@ -49,8 +49,9 @@ static unsigned int nmi_hz = HZ;
>  static DEFINE_PER_CPU(short, wd_enabled);
>  
>  /* local prototypes */
> +#ifdef CONFIG_SYSCTL
>  static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu);
> -
> +#endif
>  static int endflag __initdata = 0;

guys, please take a closer look at the code which you're changing?  We can
obviously move do_nmi_callback() down to above
__trigger_all_cpu_backtrace() and then do away with this declaration
altogether.
