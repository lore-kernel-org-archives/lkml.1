Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbYHSRox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbYHSRox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 13:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbYHSRoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 13:44:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:59696 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbYHSRoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 13:44:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KZD4mUNDgbDfpD0Ut5FSb7yNXMweOqv3a8jwQRn4Q5s7Sjczxm6VIUz5rgUO9jfgUT
         4vbyf07lQEfpPy6KXPDMAMgpY3+ECRpjTMzntd8w+vK/fnWE7TZ5IXZTMmkJ9fsRqTdE
         1l6wYpIUbyGNJYCMGWNW8upVxaxhKSWAebweY=
Message-ID: <86802c440808191044h74871ba1u62330dae18599436@mail.gmail.com>
Date: Tue, 19 Aug 2008 10:44:43 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Alex Nixon" <alex.nixon@citrix.com>
Subject: Re: [PATCH] X86: Change the default value of nr_irqs from 32 to NR_IRQs
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Jeremy Fitzhardinge" <Jeremy.Fitzhardinge@citrix.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <48AAFAE4.7070409@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AAFAE4.7070409@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 9:55 AM, Alex Nixon <alex.nixon@citrix.com> wrote:
> From: Alex Nixon <alex.nixon@citrix.com>
> Date: Tue, 19 Aug 2008 17:49:37 +0100
> Subject: [PATCH] X86:  Change the default value of nr_irqs from 32 to NR_IRQs
>
> If the number of discovered IRQs is suspiciously low, this patch causes the number reported to default to NR_IRQS, rather than 32.  NR_IRQS has already been defined to be a sensible value for the current system (in particular, at least 224 when paravirtualisation is involved).
>
> Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
> ---
>  arch/x86/kernel/io_apic.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
> index 30ff794..11bffa1 100644
> --- a/arch/x86/kernel/io_apic.c
> +++ b/arch/x86/kernel/io_apic.c
> @@ -3632,7 +3632,7 @@ int __init probe_nr_irqs(void)
>
>        /* something wrong ? */
>        if (nr < 32)
> -               nr = 32;
> +               nr = NR_IRQS;
>
>        return nr;
>  }
> --
if only one ioapic, nr will be 24<<1, you will get 48. Does pv has io apic ?

YH
