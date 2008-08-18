Return-Path: <linux-kernel-owner+w=401wt.eu-S1752332AbYHREWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbYHREWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 00:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750829AbYHREWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 00:22:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:30206 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbYHREWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 00:22:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jEZ72sCebhBq6HnNYnzlXkc4JrOrwq16v8FQP5trfc4M2vbiBi5Lh9OV008gDkHrSA
         7eRNYKG4+NkYttf0AX6E2fijbvJIhmxWK/m7wJLjJbExctvypqnC4gE7wHnH2BqQ7R8K
         cxgrtDHhScCuTXujYKlmY6jjeZisEj8Zr++ZI=
Message-ID: <aa79d98a0808172122sfab2336ldfcccc88e4316712@mail.gmail.com>
Date: Mon, 18 Aug 2008 08:22:37 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 0/9] -tip/apic merging one more series
Cc: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, macro@linux-mips.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <86802c440808171453i2869a7f3x1db27307dbec4db7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219002107-21832-1-git-send-email-gorcunov@gmail.com>
	 <86802c440808171453i2869a7f3x1db27307dbec4db7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 1:53 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> please check if you need { } otherwise you broke 64 bit
>
>
> static int lapic_resume(struct sys_device *dev)
> {
>        unsigned int l, h;
>        unsigned long flags;
>        int maxlvt;
>
>        if (!apic_pm_state.active)
>                return 0;
>
>        maxlvt = lapic_get_maxlvt();
>
>        local_irq_save(flags);
>
> #ifdef CONFIG_X86_64
>        if (x2apic)
>                enable_x2apic();
>        else
> #endif
>                /*
>                 * Make sure the APICBASE points to the right address
>                 *
>                 * FIXME! This will be wrong if we ever support suspend on
>                 * SMP! We'll need to do this as part of the CPU restore!
>                 */
>                rdmsr(MSR_IA32_APICBASE, l, h);
>                l &= ~MSR_IA32_APICBASE_BASE;
>                l |= MSR_IA32_APICBASE_ENABLE | mp_lapic_addr;
>                wrmsr(MSR_IA32_APICBASE, l, h);
>
>
> YH
>

Oh...indeed. Thanks Yinghai! - will fix it today evening.
Ingo drop this patch please (if it was applied).
