Return-Path: <linux-kernel-owner+w=401wt.eu-S932628AbXHWW43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628AbXHWW43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761261AbXHWW4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:56:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42943 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760082AbXHWW4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:56:19 -0400
Message-ID: <46CE0FC8.5060209@zytor.com>
Date: Thu, 23 Aug 2007 15:52:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Satyam Sharma <satyam@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86 msr driver: Misc cpuinit annotations
References: <alpine.LFD.0.999.0708230520070.2049@enigma.security.iitk.ac.in>
In-Reply-To: <alpine.LFD.0.999.0708230520070.2049@enigma.security.iitk.ac.in>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> msr_class_cpu_callback() can be marked __cpuinit, being the notifier
> callback for a __cpuinitdata notifier_block. So can be marked
> msr_device_create() too, called only from the newly-__cpuinit
> msr_class_cpu_callback() or from __init-marked msr_init().
> 
> Signed-off-by: Satyam Sharma <satyam@infradead.org>

Acked-by: H. Peter Anvin <hpa@zytor.com>

> ---
> 
>  arch/i386/kernel/msr.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/i386/kernel/msr.c b/arch/i386/kernel/msr.c
> index 0c1069b..ac55d85 100644
> --- a/arch/i386/kernel/msr.c
> +++ b/arch/i386/kernel/msr.c
> @@ -135,7 +135,7 @@ static const struct file_operations msr_fops = {
>  	.open = msr_open,
>  };
>  
> -static int msr_device_create(int i)
> +static int __cpuinit msr_device_create(int i)
>  {
>  	int err = 0;
>  	struct device *dev;
> @@ -146,7 +146,7 @@ static int msr_device_create(int i)
>  	return err;
>  }
>  
> -static int msr_class_cpu_callback(struct notifier_block *nfb,
> +static int __cpuinit msr_class_cpu_callback(struct notifier_block *nfb,
>  				unsigned long action, void *hcpu)
>  {
>  	unsigned int cpu = (unsigned long)hcpu;
