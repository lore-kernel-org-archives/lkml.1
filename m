Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319AbXL1T7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbXL1T7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 14:59:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbXL1T7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 14:59:46 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36360 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbXL1T7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 14:59:45 -0500
Date: Fri, 28 Dec 2007 19:58:41 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Adrian Bunk <adrian.bunk@movial.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Randy Dunlap <randy.dunlap@oracle.com>, phil.el@wanadoo.fr,
       oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Fwd: Re: [2.6.24 patch] restore ARMv6 OProfile support
Message-ID: <20071228195841.GA3945@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, hit the wrong key.  'T' and 'Y' are too close together.  (mutt)

----- Forwarded message from Russell King <rmk+lkml@arm.linux.org.uk> -----

Date: Fri, 28 Dec 2007 19:57:24 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Adrian Bunk <adrian.bunk@movial.fi>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Randy Dunlap <randy.dunlap@oracle.com>, phil.el@wanadoo.fr,
	oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org
Subject: Re: [2.6.24 patch] restore ARMv6 OProfile support

On Fri, Dec 28, 2007 at 08:56:36PM +0200, Adrian Bunk wrote:
> This patch restores the ARMv6 OProfile support that was killed by
> commit 09cadedbdc01f1a4bea1f427d4fb4642eaa19da9.
> 
> Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>

Given where we are in the release cycle, I think this "cleanup" patch
should be reverted.  Once the issues with it are resolved (why was it
never even CC'd to the arch maintainers for review?) then it can go
into mainline.

Note that it also looks like (from the commitdiff) that the above
mentioned commit also removes:

CONFIG_HARDWARE_PM (blackfin)
CONFIG_OPROFILE_CELL (powerpc)

So they're probably subtly broken as well.

Linus, what do you think?  Should 09cadedbdc01f1a4bea1f427d4fb4642eaa19da9
be reverted?

> 
> ---
> 
>  kernel/Kconfig.instrumentation |   19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> 7fc221ef169610b5eac98e2ddd641811c0d53e4a 
> diff --git a/kernel/Kconfig.instrumentation b/kernel/Kconfig.instrumentation
> index 468f47a..4453187 100644
> --- a/kernel/Kconfig.instrumentation
> +++ b/kernel/Kconfig.instrumentation
> @@ -29,2 +29,17 @@ config OPROFILE
> 
> +config OPROFILE_ARMV6
> +	bool
> +	depends on OPROFILE && ARM && CPU_V6 && !SMP
> +	default y
> +	select OPROFILE_ARM11_CORE
> +
> +config OPROFILE_MPCORE
> +	bool
> +	depends on OPROFILE && ARM && CPU_V6 && SMP
> +	default y
> +	select OPROFILE_ARM11_CORE
> +
> +config OPROFILE_ARM11_CORE
> +	bool
> +
>  config KPROBES

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

----- End forwarded message -----

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
