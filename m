Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab0CJKp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 05:45:28 -0500
Received: from mail-ew0-f216.google.com ([209.85.219.216]:60351 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab0CJKpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 05:45:12 -0500
Message-ID: <4B977815.4000703@ru.mvista.com>
Date: Wed, 10 Mar 2010 13:44:37 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Wu Zhangjin <wuzhangjin@gmail.com>
CC: Ralf Baechle <ralf@linux-mips.org>, Greg KH <gregkh@suse.de>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Loongson-2F: Flush the branch target history such
 as BTB and RAS
References: <cover.1268153722.git.wuzhangjin@gmail.com> <d513f16856e499e82f0b4e428c97fe06afb5a426.1268153722.git.wuzhangjin@gmail.com>
In-Reply-To: <d513f16856e499e82f0b4e428c97fe06afb5a426.1268153722.git.wuzhangjin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Wu Zhangjin wrote:

> From: Wu Zhangjin <wuzhangjin@gmail.com>
>
> As the Chapter 15: "Errata: Issue of Out-of-order in loongson"[1] shows, to
> workaround the Issue of Loongson-2F，We need to do:
>
> "When switching from user model to kernel model, you should flush the branch
> target history such as BTB and RAS."
>
> This patch did clear BTB(branch target buffer), forbid RAS(row address strobe)
> via Loongson-2F's 64bit diagnostic register.
>
> [1] Chinese Version: http://www.loongson.cn/uploadfile/file/200808211
> [2] English Version of Chapter 15:
> http://groups.google.com.hk/group/loongson-dev/msg/e0d2e220958f10a6?dmode=source
>
> Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
> ---
>  arch/mips/include/asm/stackframe.h |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
>
> diff --git a/arch/mips/include/asm/stackframe.h b/arch/mips/include/asm/stackframe.h
> index 3b6da33..b84cfda 100644
> --- a/arch/mips/include/asm/stackframe.h
> +++ b/arch/mips/include/asm/stackframe.h
> @@ -121,6 +121,25 @@
>  		.endm
>  #else
>  		.macro	get_saved_sp	/* Uniprocessor variation */
> +#ifdef CONFIG_CPU_LOONGSON2F
> +		/*
> +		 * Clear BTB(branch target buffer), forbid RAS(row address
> +		 * strobe)

   No spaces before the left paren...

>  to workaround the Out-of-oder Issue in Loongson2F
> +		 * via it's diagnostic register.
>   

   Only "its".

> +		 */
> +		move k0, ra
>   

   Operands misalined...

WBR, Sergei

