Return-Path: <linux-kernel-owner+w=401wt.eu-S1758613AbZEEG4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613AbZEEG4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 02:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbZEEGzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 02:55:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753928AbZEEGzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 02:55:50 -0400
Date: Mon, 4 May 2009 23:54:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM: suspend_device_irqs(): don't disable wakeup IRQs
Message-Id: <20090504235405.647772ed.akpm@linux-foundation.org>
In-Reply-To: <1241483224-7113-1-git-send-email-khilman@deeprootsystems.com>
References: <1241483224-7113-1-git-send-email-khilman@deeprootsystems.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  4 May 2009 17:27:04 -0700 Kevin Hilman <khilman@deeprootsystems.com> wrote:

> Interrupts that are flagged as wakeup sources via set_irq_wake()
> should not be disabled for suspend.
> 

Why not?

> 
> diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
> index 638d8be..99113bd 100644
> --- a/kernel/irq/pm.c
> +++ b/kernel/irq/pm.c
> @@ -28,6 +28,9 @@ void suspend_device_irqs(void)
>  	for_each_irq_desc(irq, desc) {
>  		unsigned long flags;
>  
> +		if (desc->status & IRQ_WAKEUP)
> +			continue;
> +
>  		spin_lock_irqsave(&desc->lock, flags);
>  		__disable_irq(desc, irq, true);
>  		spin_unlock_irqrestore(&desc->lock, flags);

If this fixes some bug then please provide a description of that bug?
