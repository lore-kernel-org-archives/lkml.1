Return-Path: <linux-kernel-owner+w=401wt.eu-S1758572AbYBJHdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572AbYBJHdG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 02:33:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756106AbYBJHcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 02:32:55 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:59994 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755282AbYBJHcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 02:32:54 -0500
Date: Sun, 10 Feb 2008 08:33:01 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [5/6] x86: kgdb support
Message-ID: <20080210073301.GB9805@uranus.ravnborg.org>
References: <20080210071345.GE3851@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210071345.GE3851@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 08:13:45AM +0100, Ingo Molnar wrote:
> From: Ingo Molnar <mingo@elte.hu>
> 
> simplified and streamlined kgdb support on x86, both 32-bit and 64-bit,
> based on patch from:
> 
>   Subject: kgdb: core-lite
>   From: Jason Wessel <jason.wessel@windriver.com>
> 
> [ and countless other authors - see the patch for details. ]
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86/Kconfig         |    4 
>  arch/x86/kernel/Makefile |    1 
>  arch/x86/kernel/kgdb.c   |  550 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/asm-x86/kgdb.h   |   87 +++++++
>  4 files changed, 642 insertions(+)
> 
> Index: linux-kgdb.q/arch/x86/Kconfig
> ===================================================================
> --- linux-kgdb.q.orig/arch/x86/Kconfig
> +++ linux-kgdb.q/arch/x86/Kconfig
> @@ -14,6 +14,7 @@ config X86_32
>  
>  config X86_64
>  	def_bool 64BIT
> +	select KGDB_ARCH_HAS_SHADOW_INFO
>  
>  ### Arch settings
>  config X86
> @@ -139,6 +140,9 @@ config AUDIT_ARCH
>  config ARCH_SUPPORTS_AOUT
>  	def_bool y
>  
> +config ARCH_SUPPORTS_KGDB
> +	def_bool y
> +

Please use the documented HAVE_ approach and not this
ugly "one variable per arch" idiom.
This was also commented last time the patchset were posted.

	Sam
