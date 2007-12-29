Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbXL2SIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbXL2SIP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 13:08:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754609AbXL2SIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 13:08:00 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:40083 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567AbXL2SH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 13:07:59 -0500
Date: Sat, 29 Dec 2007 10:06:18 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Adrian Bunk <adrian.bunk@movial.fi>, rmk@arm.linux.org.uk,
       phil.el@wanadoo.fr, oprofile-list@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.24 patch] Fix ARMv6 OProfile support
Message-Id: <20071229100618.304433a7.randy.dunlap@oracle.com>
In-Reply-To: <20071229160556.GA12262@Krystal>
References: <20071228185636.GA4738@stusta.de>
	<20071229160556.GA12262@Krystal>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Dec 2007 11:05:57 -0500 Mathieu Desnoyers wrote:

> Fix ARMv6 OProfile support
> 
> This patch restores the ARMv6 OProfile support that was killed by
> commit 09cadedbdc01f1a4bea1f427d4fb4642eaa19da9.
> 
> It puts the config options in arch/arm/Kconfig.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Adrian Bunk <adrian.bunk@movial.fi>
> CC: Randy Dunlap <randy.dunlap@oracle.com>
> CC: rmk@arm.linux.org.uk
> CC: phil.el@wanadoo.fr
> CC: oprofile-list@lists.sourceforge.net
> ---
>  arch/arm/Kconfig |   19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> Index: linux-2.6-lttng/arch/arm/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/arch/arm/Kconfig	2007-12-28 17:00:50.000000000 -0500
> +++ linux-2.6-lttng/arch/arm/Kconfig	2007-12-28 17:02:05.000000000 -0500
> @@ -130,6 +130,25 @@ config FIQ
>  config ARCH_MTD_XIP
>  	bool
>  
> +if OPROFILE
> +
> +config OPROFILE_ARMV6
> +	bool
> +	depends on CPU_V6 && !SMP
> +	default y
> +	select OPROFILE_ARM11_CORE
> +
> +config OPROFILE_MPCORE
> +	bool
> +	depends on CPU_V6 && SMP
> +	default y
> +	select OPROFILE_ARM11_CORE

Prefer to use "def_bool y" for the 2 config symbols above,
as you did in the Cell patch.

> +config OPROFILE_ARM11_CORE
> +	bool
> +
> +endif
> +
>  config VECTORS_BASE
>  	hex
>  	default 0xffff0000 if MMU || CPU_HIGH_VECTOR


---
~Randy
desserts:  http://www.xenotime.net/linux/recipes/
