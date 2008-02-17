Return-Path: <linux-kernel-owner+w=401wt.eu-S1755626AbYBQGL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbYBQGL2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 01:11:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbYBQGLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 01:11:21 -0500
Received: from pip23.gyao.ne.jp ([125.63.38.249]:9375 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752411AbYBQGLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 01:11:20 -0500
Date: Sun, 17 Feb 2008 15:09:55 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] h8300 CONFIG_KALLSYMS fix
Message-ID: <20080217060955.GB7780@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Sam Ravnborg <sam@ravnborg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	lkml <linux-kernel@vger.kernel.org>
References: <87abm1o2ck.wl%ysato@users.sourceforge.jp> <20080215223201.c0d08ce6.akpm@linux-foundation.org> <20080216104647.GA11043@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080216104647.GA11043@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2008 at 11:46:47AM +0100, Sam Ravnborg wrote:
> Something like this:
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 3d72dc3..f2928c5 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -29,3 +29,8 @@ config KPROBES
> 
>  config HAVE_KPROBES
>         def_bool n
> +
> +# Architectures where binutils prefix C symbols with
> +# underscore '_' shall select this symbol.
> +config SYMBOL_C_PREFIX
> +       bool
> 
> 
> Then in the relevant architectures we should do a
> 
>  config H8300
> +	select SYMBOL_C_PREFIX	# We prefix C symbols with '_'
> 
> And we should do this for all the relevant architectures:
> blackfin, v850 springs to my mind.
> For the other archs as separate patches via the respective
> maintainers.
> 
It's really a product of the toolchain, not the architecture. For SH also
we have some toolchains that do this, and others that don't. (Usually
sh-elf insteatd of sh-linux, the -elf toolchains in general are pretty
common for the nommu targets). In general we've just not supported the
symbol prefixing toolchains, but if there's a way we can handle this
cleanly at compile time then it's certainly worth trying to support.
