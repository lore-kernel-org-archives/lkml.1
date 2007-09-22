Return-Path: <linux-kernel-owner+w=401wt.eu-S1760632AbXIVTde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760632AbXIVTde (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 15:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbXIVTd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 15:33:28 -0400
Received: from www.osadl.org ([213.239.205.134]:48934 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752819AbXIVTd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 15:33:27 -0400
Subject: Re: [PATCH] [35/50] i386: Do cpuid_device_create() in
	CPU_UP_PREPARE instead of CPU_ONLINE.
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
Cc: akinobu.mita@gmail.com, hpa@zytor.com, ego@in.ibm.com, oleg@tv-sign.ru,
       patches@x86-64.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070921223235.18A2A13DCD@wotan.suse.de>
References: <200709221231.836138000@suse.de>
	 <20070921223235.18A2A13DCD@wotan.suse.de>
Content-Type: text/plain
Date: Sat, 22 Sep 2007 21:33:25 +0200
Message-Id: <1190489605.4035.104.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-09-22 at 00:32 +0200, Andi Kleen wrote:
> From: Akinobu Mita <akinobu.mita@gmail.com>
> 
> Do cpuid_device_create() in CPU_UP_PREPARE instead of CPU_ONLINE.
> 
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Signed-off-by: Andi Kleen <ak@suse.de>
> Cc: Gautham R Shenoy <ego@in.ibm.com>
> Cc: Oleg Nesterov <oleg@tv-sign.ru>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/i386/kernel/cpuid.c |   32 +++++++++++++++++++-------------
>  1 file changed, 19 insertions(+), 13 deletions(-)
> 
> Index: linux/arch/i386/kernel/cpuid.c
> ===================================================================
> --- linux.orig/arch/i386/kernel/cpuid.c
> +++ linux/arch/i386/kernel/cpuid.c
> @@ -136,15 +136,18 @@ static const struct file_operations cpui
>  	.open = cpuid_open,
>  };
>  
> -static int __cpuinit cpuid_device_create(int i)
> +static int cpuid_device_create(int cpu)

	__cpuinit please

Thanks,

	tglx



