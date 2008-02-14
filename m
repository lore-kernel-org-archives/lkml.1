Return-Path: <linux-kernel-owner+w=401wt.eu-S932194AbYBNUzC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194AbYBNUzC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:55:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbYBNUyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:54:52 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:50964 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbYBNUyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:54:51 -0500
Date: Thu, 14 Feb 2008 21:55:00 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ide: add CONFIG_IDE_ARCH_OBSOLETE_DEFAULTS
Message-ID: <20080214205500.GE21894@uranus.ravnborg.org>
References: <200802142155.50893.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802142155.50893.bzolnier@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart.

On Thu, Feb 14, 2008 at 09:55:50PM +0100, Bartlomiej Zolnierkiewicz wrote:
> Add CONFIG_IDE_ARCH_OBSOLETE_DEFAULTS to drivers/ide/Kconfig and use
> it instead of defining IDE_ARCH_OBSOLETE_DEFAULTS in <arch/ide.h>.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ide/Kconfig                 |    3 +++
>  drivers/ide/ide.c                   |    5 +++++
>  include/asm-alpha/ide.h             |    3 ---
>  include/asm-ia64/ide.h              |    2 --
>  include/asm-m32r/ide.h              |    2 --
>  include/asm-mips/mach-generic/ide.h |    2 --
>  include/asm-powerpc/ide.h           |    2 --
>  include/asm-x86/ide.h               |    2 --
>  include/linux/ide.h                 |    7 -------
>  9 files changed, 8 insertions(+), 20 deletions(-)
> 
> Index: b/drivers/ide/Kconfig
> ===================================================================
> --- a/drivers/ide/Kconfig
> +++ b/drivers/ide/Kconfig
> @@ -1099,6 +1099,9 @@ config BLK_DEV_IDEDMA
>  config IDE_ARCH_OBSOLETE_INIT
>  	def_bool ALPHA || (ARM && !ARCH_L7200) || BLACKFIN || X86 || IA64 || M32R || MIPS || PARISC || PPC || (SUPERH64 && BLK_DEV_IDEPCI) || SPARC
>  
> +config IDE_ARCH_OBSOLETE_DEFAULTS
> +	def_bool ALPHA || X86 || IA64 || M32R || MIPS || PPC32
> +
>  endif


This time it is maybe borderline as it makes sense to see a list of
archs that uses this.
But still I would prefer you did like this:

drivers/ide/Kconfig:

config HAVE_IDE_ARCH_OBSOLETE_DEFAULTS
	bool

config IDE_ARCH_OBSOLETE_DEFAULTS
	depends on HAVE_IDE_ARCH_OBSOLETE_DEFAULTS

And then in each arch Kconfig include:

arch/alpha/Kconfig:
config ALPHA
	select HAVE_ARCH_OBSOLETE_DEFAULTS

And the same for the others.

	Sam
