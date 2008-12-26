Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbYLZEXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbYLZEXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 23:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbYLZEXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 23:23:04 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:40257 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbYLZEXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 23:23:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=x9Ywyl5kO4SJjD8KlVLkeds/d+U37UDM5Tz8r/EMfpNQ3g89W2Ms3tHIKLmgol6v+G
         ppM1l9sh7YOTt22uLoaNWRwDLOEnoX9ldfuKNIVTpgLc+gHvZKC7kA+zdvl2tVagF60L
         dlT8Y22JNP8bJB7nwtGmS7yhRbE9X2G2Yk6C4=
Message-ID: <86802c440812252023tde74068y83f83efdca00eb8d@mail.gmail.com>
Date: Thu, 25 Dec 2008 20:23:01 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH for -tip 4/4] irq: for_each_irq_desc() makes simplify
Cc: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20081226122830.5CAF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081226121703.5CA3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20081226122830.5CAF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Google-Sender-Auth: 4ae7183e9f5e4e93
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2008 at 7:29 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Subject: [PATCH] irq: for_each_irq_desc() makes simplify
> Impact: cleanup
>
> all for_each_irq_desc() usage point have !desc check.
> then its check can move into for_each_irq_desc() macro.
>
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Yinghai Lu <yinghai@kernel.org>
> CC: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/io_apic.c |   10 ----------
>  drivers/xen/events.c      |    3 ---
>  include/linux/irqnr.h     |    8 ++++++--
>  kernel/irq/autoprobe.c    |   15 ---------------
>  kernel/irq/handle.c       |    3 ---
>  kernel/irq/spurious.c     |    5 -----
>  6 files changed, 6 insertions(+), 38 deletions(-)
>
> Index: b/arch/x86/kernel/io_apic.c
> ===================================================================
> --- a/arch/x86/kernel/io_apic.c
> +++ b/arch/x86/kernel/io_apic.c
> @@ -1400,8 +1400,6 @@ void __setup_vector_irq(int cpu)
>
>        /* Mark the inuse vectors */
>        for_each_irq_desc(irq, desc) {
> -               if (!desc)
> -                       continue;
>                cfg = desc->chip_data;
>                if (!cpumask_test_cpu(cpu, cfg->domain))
>                        continue;
..
> Index: b/include/linux/irqnr.h
> ===================================================================
> --- a/include/linux/irqnr.h
> +++ b/include/linux/irqnr.h
> @@ -25,10 +25,14 @@ extern struct irq_desc *irq_to_desc(unsi
>
>  # define for_each_irq_desc(irq, desc)                                  \
>        for (irq = 0, desc = irq_to_desc(irq); irq < nr_irqs;           \
> -            irq++, desc = irq_to_desc(irq))
> +            irq++, desc = irq_to_desc(irq))                            \
> +               if (desc)
> +
> +

looks good.

YH
