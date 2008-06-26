Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbYFZKGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbYFZKGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 06:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbYFZKGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 06:06:04 -0400
Received: from po-out-1718.google.com ([72.14.252.153]:33534 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbYFZKGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 06:06:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jYakRc29pCxq4BWCnkVka8TgCr950YRtaz4CXKZ1vFEySrf7HK5QD4tXPW2ZwrDouh
         TO7LKHEyxXaIJOUyGxE2sDjK0qOdBdT7fXHrgRMICwESi4IHKCNjX9PPFTG4FubyFfY2
         V/cW/ZakjzMdgGEbm5P0GDXlxzEaPhjwBfkfY=
Message-ID: <86802c440806260306o419f2369od90f1cb3c801311e@mail.gmail.com>
Date: Thu, 26 Jun 2008 03:06:01 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 00/16] x86: merge setup_32/64.c
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080626100200.GA15291@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806251748.06743.yhlu.kernel@gmail.com>
	 <20080626094743.GA19573@elte.hu> <20080626100200.GA15291@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 3:02 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>>       x86: rename setup.c to setup_percpu.c
>
> this brought a build failure:
>
>  arch/x86/kernel/setup.c: In function 'setup_arch':
>  arch/x86/kernel/setup.c:561: error: implicit declaration of function 'efi_reserve_early'
>
> 09865f3049050458a5c236e5b4630f137d9b179d is first bad commit
> commit 09865f3049050458a5c236e5b4630f137d9b179d
> Author: Yinghai Lu <yhlu.kernel@gmail.com>
> Date:   Wed Jun 25 17:48:14 2008 -0700
>
>    x86: rename setup.c to setup_percpu.c
>
> we lost an asm/efi.h include. (which, a bit illogically, is not implicit
> via the existing linux/efi.h include.) Fixed below.
>
>        Ingo
>
> -------------->
> commit 9faea5db92f5ff3b39e7b66656f847dcb9618caa
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Thu Jun 26 12:02:01 2008 +0200
>
>    x86: build fix
>
>    fix:
>
>    arch/x86/kernel/setup.c: In function 'setup_arch':
>    arch/x86/kernel/setup.c:561: error: implicit declaration of function 'efi_reserve_early'
>
>    Signed-off-by: Ingo Molnar <mingo@elte.hu>
>
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index a3f2263..29f04da 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -79,6 +79,7 @@
>  #include <asm/mpspec.h>
>  #include <asm/setup.h>
>  #include <asm/arch_hooks.h>
> +#include <asm/efi.h>
>  #include <asm/sections.h>
>  #include <asm/dmi.h>
>  #include <asm/io_apic.h>

checkpatch.pl want me to remove that.

YH
