Return-Path: <linux-kernel-owner+w=401wt.eu-S1760026AbZFWOr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760026AbZFWOr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbZFWOru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:47:50 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:59298 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbZFWOrt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:47:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ol21ubUh+/kkQ8LVNS0exWnrZ2DXN7fOtxd6Lj0ssdjL9b3SxBbcf721NgMVN6P8gE
         F/e2HWvUBgW+ZZZ674tC0Ft2pair+R7a2qEdESuJogshxnlPzdkekP06cVnma9Qba+gi
         l82KPMc/BN3gofnXAf9lLKvfNayj8vaE+7Wv0=
MIME-Version: 1.0
In-Reply-To: <4A404EC6.8080902@jp.fujitsu.com>
References: <8db1092f0906211002y2b391212ve2902fc3a6517586@mail.gmail.com>
	 <4A3EE668.5090400@jp.fujitsu.com>
	 <8db1092f0906220019x1560c26dsd5a6daa3ea612ec@mail.gmail.com>
	 <4A3F55C7.4030909@linux.intel.com>
	 <8db1092f0906220453k5595998er1400567cbcdf3e12@mail.gmail.com>
	 <4A3F7A93.5080004@linux.intel.com>
	 <8db1092f0906220627w61d9f97g88c91f770f732f03@mail.gmail.com>
	 <4A3F8BF7.6010406@linux.intel.com>
	 <8db1092f0906220755v55699d5cj697b9bdf48978bd9@mail.gmail.com>
	 <4A404EC6.8080902@jp.fujitsu.com>
Date: Tue, 23 Jun 2009 16:47:49 +0200
Message-ID: <8db1092f0906230747j1bcfe041r11bd0ffbeaa8e41a@mail.gmail.com>
Subject: Re: 2.6.30-git(16 and 17) system hangs after resume from suspend to 
	disk, mce related?
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <ak@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/23 Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>:

>
> Maciej, could you try this patch?

Tested in 2 systems (for 17 and 30 minutes). Works without any
problems. Thanks for patch!

>
> ===
> [PATCH] x86: Fix mce resume on 32bit
>
> Calling mcheck_init() on resume is required only with CONFIG_X86_OLD_MCE=y.
>
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> ---
>  arch/x86/power/cpu.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
> index d277ef1..b3d20b9 100644
> --- a/arch/x86/power/cpu.c
> +++ b/arch/x86/power/cpu.c
> @@ -244,7 +244,7 @@ static void __restore_processor_state(struct saved_context *ctxt)
>        do_fpu_end();
>        mtrr_ap_init();
>
> -#ifdef CONFIG_X86_32
> +#ifdef CONFIG_X86_OLD_MCE
>        mcheck_init(&boot_cpu_data);
>  #endif
>  }

Tested-by Maciej Rutecki <maciej.rutecki@gmail.com>


-- 
Maciej Rutecki
http://www.maciek.unixy.pl
