Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbYGEJug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbYGEJug (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 05:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbYGEJu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 05:50:28 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:53614 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbYGEJu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 05:50:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KfQ42NAwtwE4NdRcfaPlwSjUPoGBep6xvoDVCJSTsHWq/RLKrZQsfPEJ7+J1RH/FWG
         6fbe56XdynPvnIZiNnCGRzm4+pPXm0yI9MozzAllFT2VoVJUZGd084jb4IITehK2CpXl
         Ev6gusepUpGaFq/SfwEMFRyJfNQUIpqO/4Z7M=
Message-ID: <36ca99e90807050250u718fa277t2297d6436fd14c4e@mail.gmail.com>
Date: Sat, 5 Jul 2008 11:50:26 +0200
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] [9/9] MCE: Use 64bit machine check code on 32bit
Cc: masbock@linux.vnet.ibm.com, x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080704212033.D40551B431F@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807041120.678642023@firstfloor.org>
	 <20080704212033.D40551B431F@basil.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Index: linux/arch/x86/Kconfig
> ===================================================================
> --- linux.orig/arch/x86/Kconfig
> +++ linux/arch/x86/Kconfig
> @@ -652,10 +652,37 @@ config X86_MCE
>          to disable it.  MCE support simply ignores non-MCE processors like
>          the 386 and 486, so nearly everyone can say Y here.
>
> +config X86_OLD_MCE
> +       depends on X86_32
> +       bool "Use legacy machine check code (will go away)"
> +       default n
> +       help
> +         Use the old i386 machine check code. This is merely intended for testing
> +         in a transition period. Try this if you run into any machine check
> +         related software problems.
> +         When in doubt say no.
> +
> +config X86_ANCIENT_MCE
> +       depends on X86_32
> +       bool "Support ancient machine check handler for very old CPUs"
> +       default n
> +       help
> +         Include support for family 5 (Intel Pentium 1 and Centaur Winchip)
> +         machine check code.  Machine check handles uncorrected CPU errors.
> +         Note that the P5 pentium support is disabled
> +         by default and can be only enabled on special hardware.
> +         The Winchip code doesn't do much.
> +         If you're still sure you want it, say n, otherwise n is safe
Is this first "n" a typo?

Bert
