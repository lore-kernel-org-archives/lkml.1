Return-Path: <linux-kernel-owner+w=401wt.eu-S1423534AbXD3SZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423534AbXD3SZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 14:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423530AbXD3SZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 14:25:29 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33577 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946567AbXD3SZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 14:25:27 -0400
Date: Mon, 30 Apr 2007 20:25:38 +0200
From: Adrian Bunk <bunk@stusta.de>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Chinner <dgc@sgi.com>,
       Zan Lynx <zlynx@acm.org>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [1/6] make stack size configurable (was: Re: [-mm patch] i386:
	enable 4k stacks by default)
Message-ID: <20070430182538.GE23336@stusta.de>
References: <20070428191927.GN3468@stusta.de> <1177795118.7828.6.camel@localhost> <20070430035838.GC77450368@melbourne.sgi.com> <20070430091754.24df88df@the-village.bc.nu> <p73wszuyx7h.fsf@bingen.suse.de> <20070430104806.GA14944@infradead.org> <p73slaiys9v.fsf@bingen.suse.de> <20070430173819.GC19966@holomorphy.com> <20070430174047.GD19966@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070430174047.GD19966@holomorphy.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 10:40:47AM -0700, William Lee Irwin III wrote:
> On Mon, Apr 30, 2007 at 10:38:19AM -0700, William Lee Irwin III wrote:
> > Here's what I did for i386 for someone concerned about blowing the stack.
> 
> Make more stack sizes configurable, adding options for deeper stacks.
> This is largely for differential diagnosis in cases where stack overflows
> are suspected of silently corrupting memory or causing other problems not
> detected immediately.
> 
> Signed-off-by: William Irwin <wli@holomorphy.com>
> 
> 
> Index: stack-paranoia/arch/i386/Kconfig.debug
> ===================================================================
> --- stack-paranoia.orig/arch/i386/Kconfig.debug	2007-04-30 10:26:15.863869853 -0700
> +++ stack-paranoia/arch/i386/Kconfig.debug	2007-04-30 10:31:43.878562345 -0700
> @@ -56,6 +56,10 @@
>  	  portion of the kernel code won't be covered by a 2MB TLB anymore.
>  	  If in doubt, say "N".
>  
> +choice
> +	prompt "Stack size"
> +	default 8KSTACKS
> +
>  config 4KSTACKS
>  	bool "Use 4Kb for kernel stacks instead of 8Kb"
>  	depends on DEBUG_KERNEL
> @@ -66,6 +70,37 @@
>  	  on the VM subsystem for higher order allocations. This option
>  	  will also use IRQ stacks to compensate for the reduced stackspace.
>  
> +config 8KSTACKS
> +	bool "Use 8KB for kernel stacks"
> +	help
> +	  If you say Y here, the kernel will use its standard stacksize.
>...

These are no questions a user should ever see, and it's impossible that 
a user will be able to choose the right answer - that's an 
implementation detail, and it has to be set correctly automatically 
without bothering the user.

Pro of bigger stacks:
- kernel developers have to care less about stack usage

Pros of smaller stacks:
- less memory usage
- higher order allocations are more likely to fail with fragmented
  memory

We are currently at "works with 8k stacks and without separate IRQ stacks"
and at "works in most situations with 4k stacks", so nothing > 8k should 
be required.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

