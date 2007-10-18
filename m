Return-Path: <linux-kernel-owner+w=401wt.eu-S933380AbXJROpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933380AbXJROpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 10:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbXJROpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 10:45:38 -0400
Received: from h155.mvista.com ([63.81.120.155]:43549 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751396AbXJROph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 10:45:37 -0400
Message-ID: <4717719C.703@ru.mvista.com>
Date: Thu, 18 Oct 2007 18:45:48 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: tglx@linutronix.de, mingo@elte.hu, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
References: <200705172142.26739.sshtylyov@ru.mvista.com>
In-Reply-To: <200705172142.26739.sshtylyov@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
> Add PowerPC decrementer clock event driver.

> Every effort has been made to support the different implementations of the
> decrementer: the classic one (with 970 series variation), 40x and Book E
> specific ones.

> I had to make CONFIG_GENERIC_CLOCKEVENTS option selectable for the
> compatibility reasons -- this option is not compatible with the PPC64
> deterministic time accounting.

> Thanks to Daniel Walker and Thomas Gleixner for the suggestions they made...

> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

> Index: linux-2.6/arch/powerpc/Kconfig
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/Kconfig
> +++ linux-2.6/arch/powerpc/Kconfig
> @@ -317,7 +317,7 @@ config PPC_STD_MMU_32
>  
>  config VIRT_CPU_ACCOUNTING
>  	bool "Deterministic task and CPU time accounting"
> -	depends on PPC64
> +	depends on PPC64 && !GENERIC_CLOCKEVENTS
>  	default y
>  	help
>  	  Select this option to enable more accurate task and CPU time

    Thomas, that part of the ppc-clockevents.patch (part of the -rt patch) is 
now broken, it makes CONFIG_MAX_ZONEORDER dependent on 
!CONFIG_GENERIC_CLOCKEVENTS -- this is probably due to patch's fuzzy logic.
Do I need to send a patch to fix this?

WBR, Sergei
