Return-Path: <linux-kernel-owner+w=401wt.eu-S1758954AbYHSA46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758954AbYHSA46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 20:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756813AbYHSAs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 20:48:59 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:57562 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756801AbYHSAs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 20:48:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nFBrZiOLZalk69Wfn9nTLur5Jy/Kxi5x/kIegvH2gYEGiAXP1Ym6Tj4WmJ4pwjhXp4
         vd2bXfBy3jHogBd9sv2BBOsrMLDQ6PxF0iXwXCuMw5rLA1YA8X2G8oOAxuiuG98UpJOT
         InoMPIcxhzGnLW9AQfsVMxghDtwksT1tpGdvw=
Message-ID: <86802c440808181748m62544821pd0c4a3eb4bed60bb@mail.gmail.com>
Date: Mon, 18 Aug 2008 17:48:56 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] irq: rename irq_desc() to to_irq_desc() - fix #3
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080819003856.GA5486@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219092290-30154-1-git-send-email-yhlu.kernel@gmail.com>
	 <1219092290-30154-2-git-send-email-yhlu.kernel@gmail.com>
	 <1219092290-30154-3-git-send-email-yhlu.kernel@gmail.com>
	 <20080819001126.GB9914@elte.hu> <20080819003856.GA5486@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 5:38 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>
>> > add create_irq_nr, and retore create_irq to old
>>
>> applied all 3 patches to tip/irq/sparseirq - thanks Yinghai!
>
> build fix for tip/master, from tip/x86/spinlocks. I merged that branch
> into tip/irq/sparseirq and applied this fix.
>
>        Ingo
>
> ------------>
> From 1f73df742c77472d2e14e47b8c568218952af1d7 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 19 Aug 2008 02:33:39 +0200
> Subject: [PATCH] irq: build fix
>
> fix:
>
>  arch/x86/xen/spinlock.c: In function 'xen_spin_lock_slow':
>  arch/x86/xen/spinlock.c:90: error: 'struct kernel_stat' has no member named 'irqs'
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/xen/spinlock.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
> index 8dc4d31..dc21378 100644
> --- a/arch/x86/xen/spinlock.c
> +++ b/arch/x86/xen/spinlock.c
> @@ -87,7 +87,7 @@ static noinline int xen_spin_lock_slow(struct raw_spinlock *lock)
>
>        /* block until irq becomes pending */
>        xen_poll_irq(irq);
> -       kstat_this_cpu.irqs[irq]++;
> +       kstat_irqs_this_cpu(&irq_desc[irq])++;
>
>  out:
>        unspinning_lock(xl);
>

should be

kstat_irqs_this_cpu(to_irq_desc(irq))++;

otherwise when CONFIG_HAVE_SPARSE_IRQ is set, it will fail.

when sparse_irq is set, only have irq_descX list...

YH
