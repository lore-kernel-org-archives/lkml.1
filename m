Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbYGNRAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbYGNRAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 13:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbYGNRAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 13:00:30 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:9147 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbYGNRA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 13:00:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UMA7U6mXJdP44KT/3rfVOTfFtt0XzqYZfOfXAgc2qgNHh5DeRDezn/BE1rpRURJf1x
         eFHUQSv3pR3QnOJiT0AKZfZoocH4/aIc+gIQWzkk8cMmegL3QFvuE1M+8C6j4eYDCasF
         RNR+6cdfeWYs5LBu5/gJTCAnrevUkfL+dQ2P4=
Message-ID: <86802c440807141000x106cf885s6de0aad9804112bf@mail.gmail.com>
Date: Mon, 14 Jul 2008 10:00:28 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Suresh Siddha" <suresh.b.siddha@intel.com>
Subject: Re: [PATCH] x86: let 32bit use apic_ops too - fix
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080714164913.GK1678@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807080141.05436.yhlu.kernel@gmail.com>
	 <200807102038.26591.yhlu.kernel@gmail.com>
	 <200807111841.55403.yhlu.kernel@gmail.com>
	 <200807132219.35814.yhlu.kernel@gmail.com>
	 <20080714071207.GB17077@elte.hu>
	 <20080714164913.GK1678@linux-os.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2008 at 9:49 AM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> On Mon, Jul 14, 2008 at 12:12:07AM -0700, Ingo Molnar wrote:
>>
>> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>
>> > fix for pv.
>> >
>> > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>
>> applied to tip/x86/x2apic - thanks Yinghai.
>
> Ingo, before you try for the third attempt ;) we need one more lguest apic_ops
> fix. Patch appended. Thanks.
>
> ---
> [patch] x86: apic_ops for lguest
>
> apic_ops for lguest.
>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Cc: Yinghai Lu <yhlu.kernel@gmail.com>
> ---
>
> Index: x86.git/arch/x86/lguest/boot.c
> ===================================================================
> --- x86.git.orig/arch/x86/lguest/boot.c 2008-07-14 09:44:31.000000000 -0700
> +++ x86.git/arch/x86/lguest/boot.c      2008-07-14 09:45:12.000000000 -0700
> @@ -791,6 +791,37 @@
>  {
>        return 0;
>  }
> +
> +static u64 lguest_apic_icr_read(void)
> +{
> +       return 0;
> +}
> +
> +static void lguest_apic_icr_write(u32 low, u32 id)
> +{
> +       /* Warn to see if there's any stray references */
> +       WARN_ON(1);
> +}
> +
> +static void lguest_apic_wait_icr_idle(void)
> +{
> +       return;
> +}
> +
> +static u32 lguest_apic_safe_wait_icr_idle(void)
> +{
> +       return 0;
> +}
> +
> +static struct apic_ops lguest_basic_apic_ops = {
> +       .read = lguest_apic_read,
> +       .write = lguest_apic_write,
> +       .write_atomic = lguest_apic_write,
> +       .icr_read = lguest_apic_icr_read,
> +       .icr_write = lguest_apic_icr_write,
> +       .wait_icr_idle = lguest_apic_wait_icr_idle,
> +       .safe_wait_icr_idle = lguest_apic_safe_wait_icr_idle,
> +};
>  #endif
>
>  /* STOP!  Until an interrupt comes in. */
> @@ -990,9 +1021,7 @@
>
>  #ifdef CONFIG_X86_LOCAL_APIC
>        /* apic read/write intercepts */
> -       pv_apic_ops.apic_write = lguest_apic_write;
> -       pv_apic_ops.apic_write_atomic = lguest_apic_write;
> -       pv_apic_ops.apic_read = lguest_apic_read;
> +       apic_ops = &lguest_basic_apic_ops;
>  #endif
>
>        /* time operations */

do we need one for KVM pv?

YH
