Return-Path: <linux-kernel-owner+w=401wt.eu-S1755060AbYKBVfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbYKBVfm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 16:35:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbYKBVfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 16:35:33 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:58203 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249AbYKBVfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 16:35:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UBmujBV0ekejBAdd17mAyHSZXSyE9LfeoKIVxxK2O2y+uXUW/Z0MQddQrP0s5CaTZZ
         JSOEwQx3I/XE22hagrySDDvXStCO+o8EOLWtURhP7azxg+oj8hTgFGhgScZ2ib/UkTu+
         2x2XEcdEB7zUG7QNiNKDfigvi1hq1ZdLE3aig=
Message-ID: <87a5b0800811021335nfe6202fwc00681ec96d9816c@mail.gmail.com>
Date: Sun, 2 Nov 2008 21:35:31 +0000
From: "Will Newton" <will.newton@gmail.com>
To: "Matt Fleming" <mjf@gentoo.org>
Subject: Re: [PATCH 2/3] HPET: Enter hpet_interrupt_handler with interrupts disabled
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       venkatesh.pallipadi@intel.com
In-Reply-To: <1225641860-6120-2-git-send-email-mjf@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225641860-6120-1-git-send-email-mjf@gentoo.org>
	 <1225641860-6120-2-git-send-email-mjf@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 2, 2008 at 4:04 PM, Matt Fleming <mjf@gentoo.org> wrote:
> Some functions that may be called from this handler require that
> interrupts are disabled.
>
> Signed-off-by: Matt Fleming <mjf@gentoo.org>
> ---
>  arch/x86/kernel/hpet.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> index f10f946..c28fff2 100644
> --- a/arch/x86/kernel/hpet.c
> +++ b/arch/x86/kernel/hpet.c
> @@ -445,7 +445,8 @@ static int hpet_setup_irq(struct hpet_dev *dev)
>  {
>
>        if (request_irq(dev->irq, hpet_interrupt_handler,
> -                       IRQF_SHARED|IRQF_NOBALANCING, dev->name, dev))
> +                       IRQF_DISABLED|IRQF_SHARED|IRQF_NOBALANCING,
> +                       dev->name, dev))

Combining IRQF_DISABLED and IRQF_SHARED does not reliably disable
interrupts in the handler. Perhaps IRQF_SHARED should be removed at
the same time?

>                return -1;
>
>        disable_irq(dev->irq);
> --
> 1.5.6.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
