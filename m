Return-Path: <linux-kernel-owner+w=401wt.eu-S1752835AbZGVHKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbZGVHKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 03:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbZGVHKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 03:10:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42289 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbZGVHKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 03:10:48 -0400
Date: Wed, 22 Jul 2009 09:10:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       linux-pm@lists.linux-foundation.org, len.brown@intel.com,
       yanh@lemote.com, linux-kernel@vger.kernel.org, zhangfx@lemote.com
Subject: Re: [linux-pm] [PATCH] [suspend] pci_raw_set_power_state: replace
	msleep by udelay in resuming procedure
Message-ID: <20090722071039.GD29955@elf.ucw.cz>
References: <Pine.LNX.4.44L0.0907161259510.2952-100000@iolanthe.rowland.org> <1247796643.19112.77.camel@falcon> <200907170433.42366.rjw@sisk.pl> <1248229436.12360.27.camel@falcon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248229436.12360.27.camel@falcon>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Perhaps it's necessary to annotate your timer interrupts appropriately so that
> > they are not disabled during suspend?
> 
> Thanks very much, The IRQF_TIMER flag works for me, so the replacement
> of msleep by udelay is not needed.
> 
> [This source code is not ready to upstream, herein, just a prompt to the
> other guys who will meet the same problem.]

Unlike the other patch, this one actually looks ok.

> Adding IRQF_TIMER to the interupt flags when requesting the mfgpt timer
> interrupts solves the problem.
> 
> Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
> ---
>  arch/mips/loongson/common/cs5536/cs5536_mfgpt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/mips/loongson/common/cs5536/cs5536_mfgpt.c
> b/arch/mips/loongson/common/cs5536/cs5536_mfgpt.c
> index 1a518ec..5b8fa9f 100644
> --- a/arch/mips/loongson/common/cs5536/cs5536_mfgpt.c
> +++ b/arch/mips/loongson/common/cs5536/cs5536_mfgpt.c
> @@ -133,7 +133,7 @@ static irqreturn_t timer_interrupt(int irq, void
> *dev_id)
>  
>  static struct irqaction irq5 = {
>  	.handler = timer_interrupt,
> -	.flags = IRQF_DISABLED | IRQF_NOBALANCING,
> +	.flags = IRQF_TIMER | IRQF_DISABLED | IRQF_NOBALANCING,
>  	.name = "timer"
>  };


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
