Return-Path: <linux-kernel-owner+w=401wt.eu-S1764904AbXHWW4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764904AbXHWW4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932845AbXHWW4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:56:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42950 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932580AbXHWW43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:56:29 -0400
Message-ID: <46CE0FD9.1030008@zytor.com>
Date: Thu, 23 Aug 2007 15:53:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Satyam Sharma <satyam@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386 cpuid: Misc cpuinit annotations
References: <alpine.LFD.0.999.0708230507160.2049@enigma.security.iitk.ac.in>
In-Reply-To: <alpine.LFD.0.999.0708230507160.2049@enigma.security.iitk.ac.in>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> cpuid_class_cpu_callback() is callback function of a CPU hotplug
> notifier_block (that is already marked as __cpuinitdata). Therefore
> it can safely be marked as __cpuinit.
> 
> cpuid_device_create() is only referenced from other functions that
> are __cpuinit or __init. So it can also be safely marked __cpuinit.
> 
> Signed-off-by: Satyam Sharma <satyam@infradead.org>

Acked-by: H. Peter Anvin <hpa@zytor.com>

>  arch/i386/kernel/cpuid.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/i386/kernel/cpuid.c b/arch/i386/kernel/cpuid.c
> index 5c2faa1..a6761fd 100644
> --- a/arch/i386/kernel/cpuid.c
> +++ b/arch/i386/kernel/cpuid.c
> @@ -152,7 +152,7 @@ static const struct file_operations cpuid_fops = {
>  	.open = cpuid_open,
>  };
>  
> -static int cpuid_device_create(int i)
> +static int __cpuinit cpuid_device_create(int i)
>  {
>  	int err = 0;
>  	struct device *dev;
> @@ -163,7 +163,9 @@ static int cpuid_device_create(int i)
>  	return err;
>  }
>  
> -static int cpuid_class_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
> +static int __cpuinit cpuid_class_cpu_callback(struct notifier_block *nfb,
> +					      unsigned long action,
> +					      void *hcpu)
>  {
>  	unsigned int cpu = (unsigned long)hcpu;
>  
