Return-Path: <linux-kernel-owner+w=401wt.eu-S1756725AbYHNRe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbYHNRe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 13:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbYHNReU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 13:34:20 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:40584 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbYHNReT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 13:34:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Db9VHhxCYaXlBGzBd2McXnM4LvuHu3ZRwIv1nW4zNw1vTlJTd/hF3BkqeNa7rHFQbn
         HAtadkUOO25xIxrem0INSaDZPDhv/8vZ30IA4Ln0SuSestiDvpQCkFhKgFFiSsxyPE9r
         WnSVwjItSwFVbLDP0BumlGMrWErv/h+VTxSzM=
Message-ID: <86802c440808141034g15542e2i1bdaf4615264df98@mail.gmail.com>
Date: Thu, 14 Aug 2008 10:34:18 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] irq: sparse irqs, fix #3
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080814140733.GA31829@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218705441-21838-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080814132638.GA18743@elte.hu> <20080814140733.GA31829@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 7:07 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> From 1b53f0444df394e4448ba56694f0bc4dda2bece0 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Thu, 14 Aug 2008 16:07:04 +0200
> Subject: [PATCH] irq: sparse irqs, fix #3
>
> fix non-APIC UP build:
>
>  arch/x86/kernel/built-in.o: In function `setup_arch':
>  : undefined reference to `pin_map_size'
>  arch/x86/kernel/built-in.o: In function `setup_arch':
>  : undefined reference to `first_free_entry'
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/setup.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 24e984e..8318a35 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -863,8 +863,10 @@ void __init setup_arch(char **cmdline_p)
>                nr_irqs = 32 * nr_cpu_ids + 224;
>        init_cpu_to_node();
>  #endif
> +#ifdef CONFIG_X86_LOCAL_APIC
>        pin_map_size = nr_irqs * 2;
>        first_free_entry = nr_irqs;
> +#endif
>
>        init_apic_mappings();
>        ioapic_init_mappings();
>

we don't need pin_map_size and first_free_entry after 64 and 32 bit
all put irq_2_pin in irq_cfg.

need to remove them.

YH
