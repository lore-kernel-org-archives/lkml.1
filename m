Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbZFUU1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbZFUU1U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 16:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbZFUU1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 16:27:12 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:57788 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbZFUU1L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 16:27:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=T7mRDfs0Wh+zZnQ7Q5DM4TblKxlf3GBHC/3/MngeoPmruz6PZkGfc54MB9z7oUH8UY
         IXkFJ+0aqXkruCnxS2mQLoZTNL8EN2o8XK44f3DhnN9vUfQT4VJ8hOPSzBMIoAYKGKa+
         eGDhfFAkMM2sD3fD6kNAahTf3H2TqPznFNVGY=
MIME-Version: 1.0
In-Reply-To: <ac8f92700906202326u4de4311bjc77bb81ef93b81f9@mail.gmail.com>
References: <ac8f92700906202315w7d274a98oa3abe6dcc7f9ede1@mail.gmail.com>
	 <ac8f92700906202326u4de4311bjc77bb81ef93b81f9@mail.gmail.com>
Date: Sun, 21 Jun 2009 13:27:13 -0700
Message-ID: <86802c440906211327o7b6d1532x2fac9d85fec7148@mail.gmail.com>
Subject: Re: patch for linux-2.6.30/arch/x86_64/mm/init.c
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: jing zhang <zj.barak@gmail.com>, Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 20, 2009 at 11:26 PM, jing zhang<zj.barak@gmail.com> wrote:
> hi,
>
> I have no way sending to Andi Kleen, then try Mr. linux-kernel and Mr.
> Ingo Molnar.
>
> btw, AC's mailbox @ suse closed, and why?

he is not working for them.

>
> thank you
>
> ---------- Forwarded message ----------
> From: jing zhang <zj.barak@gmail.com>
> Date: Sun, 21 Jun 2009 14:15:09 +0800
> Subject: patch for linux-2.6.30/arch/x86_64/mm/init.c
> To: ak@suse.de
>
> Good Sunday Mr. Andi Kleen,
>
> It seems that in function
>    unsigned long __init_refok
>    init_memory_mapping(unsigned long start, unsigned long end)
>
> CONFIG_DEBUG_PAGEALLOC conflicts with use_pse and use_gbpages when
> CONFIG_X86_32 also defined.
>
> The following is my patch to you,
>
> best
>
> look forwar to your opion.
> zj
>
> //<<<<<<<<<<<<<<<<<<<<<
>
> #ifdef CONFIG_DEBUG_PAGEALLOC
>        /*
>         * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
>         * This will simplify cpa(), which otherwise needs to support splitting
>         * large pages into small in interrupt context, etc.
>         */
>        use_pse = use_gbpages = 0;
> #else
>        use_pse = cpu_has_pse;
>        use_gbpages = direct_gbpages;
> #endif
>
> #ifdef CONFIG_X86_32
> #ifdef CONFIG_X86_PAE
>        set_nx();
>        if (nx_enabled)
>                printk(KERN_INFO "NX (Execute Disable) protection: active\n");
> #endif
>        /* Enable PSE if available */
> -       if (cpu_has_pse)
> +       /* and #ifdef CONFIG_DEBUG_PAGEALLOC */
> +       if (cpu_has_pse && use_pse)
>                set_in_cr4(X86_CR4_PSE);
>
>        /* Enable PGE if available */
> -       if (cpu_has_pge) {
> +       /* and #ifdef CONFIG_DEBUG_PAGEALLOC */
> +       if (cpu_has_pge && use_gbpages) {
>                set_in_cr4(X86_CR4_PGE);
>                __supported_pte_mask |= _PAGE_GLOBAL;

pge and gbpages is not same ...

also wonder what is code based for?

please check tip/master
http://people.redhat.com/mingo/tip.git/readme.txt

YH
