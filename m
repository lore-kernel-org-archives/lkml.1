Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbYIFDB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbYIFDB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 23:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbYIFDBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 23:01:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:48423 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbYIFDBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 23:01:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=aVsQW8X+K8HRR1wNKFypmBQgUYA71hdGEtRtyMBMXDX01y2T/7KJ0zMqILcQEmfo3O
         Az4dDkI03TH3PSYbws17Slv6805WbX/lfR7+Dr8EjtXzceDhk/6mJ9y2PQETfd3Yl+Yu
         xCxPiYGJn6N49J1OQYp63K7CxVxPVHH8vDFfE=
Message-ID: <86802c440809052001o71892669ofe42ee4772654eeb@mail.gmail.com>
Date: Fri, 5 Sep 2008 20:01:16 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 fixes (NOPL issue)
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "x86 maintainers" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200809060222.m862MVtP024813@askone.hos.anvin.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200809060222.m862MVtP024813@askone.hos.anvin.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2008 at 7:22 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Hi Linus,
>
> Please pull:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus-2
>
> H. Peter Anvin (4):
>      x86: boot: stub out unimplemented CPU feature words
 diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 80ab20d..0785b3c 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -13,6 +13,7 @@
>  #include <asm/mtrr.h>
>  #include <asm/mce.h>
>  #include <asm/pat.h>
> +#include <asm/asm.h>
>  #ifdef CONFIG_X86_LOCAL_APIC
>  #include <asm/mpspec.h>
>  #include <asm/apic.h>
> @@ -341,6 +342,35 @@ static void __init early_cpu_detect(void)
>        early_get_cap(c);
>  }
>
> +/*
> + * The NOPL instruction is supposed to exist on all CPUs with
> + * family >= 6, unfortunately, that's not true in practice because
> + * of early VIA chips and (more importantly) broken virtualizers that
> + * are not easy to detect.  Hence, probe for it based on first
> + * principles.
> + */

if so, should only test on VIA chips.

YH
