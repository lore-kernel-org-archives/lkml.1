Return-Path: <linux-kernel-owner+w=401wt.eu-S1760273AbYBFGuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760273AbYBFGuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 01:50:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbYBFGuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 01:50:11 -0500
Received: from mxsf07.insightbb.com ([74.128.0.77]:65140 "EHLO
	mxsf07.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbYBFGuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 01:50:08 -0500
X-IronPort-AV: E=Sophos;i="4.25,311,1199682000"; 
   d="scan'208";a="234320097"
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FACrnqEdKjlCP/2dsb2JhbACBWaxB
X-IronPort-AV: E=Sophos;i="4.25,311,1199682000"; 
   d="scan'208";a="153822396"
From: Dmitry Torokhov <dtor@insightbb.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] Input updates for 2.6.25-rc0
Date: Wed, 6 Feb 2008 01:49:50 -0500
User-Agent: KMail/1.9.3
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200802060108.31644.dtor@insightbb.com> <20080205223242.f444fad6.akpm@linux-foundation.org>
In-Reply-To: <20080205223242.f444fad6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802060149.50879.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 February 2008 01:32, Andrew Morton wrote:
> 
> Looks OK.  Minorish things from a quick scan:
> 
> 
> 
> tosakbd_scankeyboard() looks like it'll spend a perfectly wicked amount of
> time under spin_lock_irqsave().
>

I think you are right. I will check with Dmitry if it can be relaxed a bit.
 
> 
> 
> This code, in tosakbd_probe():
> 
> +fail2:
> +	while (--i >= 0)
> +		gpio_free(TOSA_GPIO_KEY_STROBE(i));
> +
> +	i = TOSA_KEY_SENSE_NUM;
> +fail:
> +	while (--i >= 0) {
> +		free_irq(gpio_to_irq(TOSA_GPIO_KEY_SENSE(i)), pdev);
> +		gpio_free(TOSA_GPIO_KEY_SENSE(i));
> +	}
> 
> looks like it'll free irqs and gpios which were never allocated (if i <
> TOSA_KEY_SENSE_NUM on entry).
>

Umm? There are 2 groups of gpios (sense and strobe) with sense group
registered first. Looks ok to me.
 
> 
> 
> +static int __devinit tosakbd_probe(struct platform_device *pdev) {
> 
> please integrate checkpatch into your merging process.
>

Will do.
 
> 
> 
> 
> i8042_platform_init():
> 
> +#if defined(__i386__) || defined(__x86_64__)
> 
> use #ifdef CONFIG_X86?
> 

I considered it but above was tested and in line with the style of the
rest of the file...
 
-- 
Dmitry
