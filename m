Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbYDENsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbYDENsQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 09:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbYDENsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 09:48:00 -0400
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:26270 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbYDENr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 09:47:59 -0400
Date: Sat, 5 Apr 2008 15:46:26 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] boot: increase stack size for kernel boot loader decompressor
Message-ID: <20080405134626.GA15894@mailshack.com>
References: <20080405013014.478571000@polaris-admin.engr.sgi.com> <20080405013014.693571000@polaris-admin.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080405013014.693571000@polaris-admin.engr.sgi.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Sat, 05 Apr 2008 15:47:30 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.81; VDF: 7.0.3.121; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2008 at 06:30:15PM -0700, Mike Travis wrote:
>   * Increase stack size for the kernel bootloader decompressor.  This is
>     needed to boot a kernel with NR_CPUS = 4096.  I tested with 8k stack
>     size but that wasn't sufficient.
> 
> Based on:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>     +   x86/latest          .../x86/linux-2.6-x86.git
>     +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git
> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> ---
>  arch/x86/boot/compressed/head_64.S |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.25-rc5.orig/arch/x86/boot/compressed/head_64.S
> +++ linux-2.6.25-rc5/arch/x86/boot/compressed/head_64.S
> @@ -314,5 +314,5 @@ gdt_end:
>  /* Stack for uncompression */
>  	.balign 4
>  user_stack:
> -	.fill 4096,4,0
> +	.fill 16384,4,0
--------------^^^ * ^

Changed from 16K to 64K. I wonder what is using so much space on
this stack?

>  user_stack_end:
> 
> -- 
