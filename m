Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbYFSBaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbYFSBaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 21:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbYFSB3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 21:29:51 -0400
Received: from mail.windriver.com ([147.11.1.11]:33965 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbYFSB3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 21:29:51 -0400
Message-ID: <4859B650.9030208@windriver.com>
Date: Wed, 18 Jun 2008 20:28:48 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Ben Dooks <ben-linux@fluff.org>
CC: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: linux-next: fix vector initialisation when !CONFIG_KGDB
References: <20080618165021.GJ10351@trinity.fluff.org>
In-Reply-To: <20080618165021.GJ10351@trinity.fluff.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Jun 2008 01:28:49.0672 (UTC) FILETIME=[D36BA880:01C8D1AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ben Dooks wrote:
> It seems in the changes for adding CONFIG_KGDB that the ARM
> trap initialisation has been turned off if the configuration
> is not enabled. If CONFIG_KGDB is not set, the system locks
> up as soon as the kernel turns the IRQs on for the first
> time in init/main.c.
>
> The fix is to remove the dependency on calling early_trap_init()
> on CONFIG_KGDB, so that the vectors are initialised before
> the init sequence enables the IRQs.
>
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>
>
> --- linux-2.6.26-rc6-q1.orig/arch/arm/kernel/setup.c	2008-06-18 15:17:31.000000000 +0100
> +++ linux-2.6.26-rc6-q1/arch/arm/kernel/setup.c	2008-06-18 15:17:45.000000000 +0100
> @@ -855,9 +855,7 @@ void __init setup_arch(char **cmdline_p)
>  #endif
>  #endif
>  
> -#if defined(CONFIG_KGDB)
>  	early_trap_init();
> -#endif
>  }
>
>   

That is absolutely correct.  Thanks for catching this.

I folded this into the general ARM kgdb patch as there is no sense in
generating a patch bisecting failure.  The change is in the kgdb-next
branch which feeds into the linux-next, which means it should show up in
the next day or so.

Thanks,
Jason.
