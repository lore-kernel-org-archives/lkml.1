Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302AbZKNBDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbZKNBDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 20:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbZKNBDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 20:03:40 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:57181 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbZKNBDj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 20:03:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CZstthjaiGaawpS6WB4N2dRODcZJ1z3//DZ3OYB0+r20NAJtbZtIsxIN+yGuvVB7aj
         sHcZDhfoiW2+g9NDt/EgMYz+HIXHI3akgO+muLo1SqBsyn+7O/PgPVETx9y27HwwmX1q
         2Pz2QPiEkKI1NBdF87Z+pYaOCRKBsNblJ9e6g=
MIME-Version: 1.0
In-Reply-To: <tip-0388423dba2217b4e5b6c61690b0506d13b25a49@git.kernel.org>
References: <20091113203000.GA19160@redhat.com>
	 <tip-0388423dba2217b4e5b6c61690b0506d13b25a49@git.kernel.org>
Date: Fri, 13 Nov 2009 17:03:44 -0800
Message-ID: <86802c440911131703y35520496pfbdaa4e0bd8f8609@mail.gmail.com>
Subject: Re: [tip:x86/debug] x86: Minimise printk spew from per-vendor init 
	code
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, davej@redhat.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 4:33 PM, tip-bot for Dave Jones
<davej@redhat.com> wrote:
> Commit-ID:  0388423dba2217b4e5b6c61690b0506d13b25a49
> Gitweb:     http://git.kernel.org/tip/0388423dba2217b4e5b6c61690b0506d13b25a49
> Author:     Dave Jones <davej@redhat.com>
> AuthorDate: Fri, 13 Nov 2009 15:30:00 -0500
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sat, 14 Nov 2009 01:18:05 +0100
>
> x86: Minimise printk spew from per-vendor init code
>
> In the default case where the kernel supports all CPU vendors,
> we currently print out a bunch of not useful messages on every
> system.
>
> 32-bit:
> KERNEL supported cpus:
>  Intel GenuineIntel
>  AMD AuthenticAMD
>  NSC Geode by NSC
>  Cyrix CyrixInstead
>  Centaur CentaurHauls
>  Transmeta GenuineTMx86
>  Transmeta TransmetaCPU
>  UMC UMC UMC UMC
>
> 64-bit:
> KERNEL supported cpus:
>  Intel GenuineIntel
>  AMD AuthenticAMD
>  Centaur CentaurHauls
>
> Given that "what CPUs does the kernel support" isn't useful for
> the "support everything" case, we can suppress these printk's.
>
> Signed-off-by: Dave Jones <davej@redhat.com>
> LKML-Reference: <20091113203000.GA19160@redhat.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/cpu/common.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index cc25c2b..617a29f 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -656,6 +656,7 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
>
>  void __init early_cpu_init(void)
>  {
> +#ifdef PROCESSOR_SELECT
>        const struct cpu_dev *const *cdev;
>        int count = 0;
>
> @@ -676,7 +677,7 @@ void __init early_cpu_init(void)
>                                cpudev->c_ident[j]);
>                }
>        }
> -
> +#endif
>        early_identify_cpu(&boot_cpu_data);
>  }

NACK.

the function is initializing cpu_devs array.

YH
