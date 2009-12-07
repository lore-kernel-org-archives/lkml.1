Return-Path: <linux-kernel-owner+w=401wt.eu-S935220AbZLGO25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935220AbZLGO25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 09:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935177AbZLGO2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 09:28:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935176AbZLGO2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 09:28:54 -0500
Message-ID: <4B1D1105.3060506@redhat.com>
Date: Mon, 07 Dec 2009 09:28:21 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: compile insn.c and inat.c only for KPROBES
References: <878wdg8icq.fsf@devron.myhome.or.jp>
In-Reply-To: <878wdg8icq.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi wrote:
>
> At least, insn.c and inat.c is needed for kprobe for now. So, this
> compile those only if KPROBES is enabled.
>
> Signed-off-by: OGAWA Hirofumi<hirofumi@mail.parknet.co.jp>

Right, currently, the decoder is only used by kprobes.
Thank you,

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

> ---
>
>   arch/x86/Kconfig.debug |    4 ++--
>   arch/x86/lib/Makefile  |    2 +-
>   2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff -L arch/x86/lib/Kconfig -puN /dev/null /dev/null
> diff -puN arch/x86/lib/Makefile~kconfig-decoder-only-for-kprobe arch/x86/lib/Makefile
> --- linux-2.6/arch/x86/lib/Makefile~kconfig-decoder-only-for-kprobe	2009-12-06 19:49:06.000000000 +0900
> +++ linux-2.6-hirofumi/arch/x86/lib/Makefile	2009-12-06 19:49:06.000000000 +0900
> @@ -20,7 +20,7 @@ lib-y := delay.o
>   lib-y += thunk_$(BITS).o
>   lib-y += usercopy_$(BITS).o getuser.o putuser.o
>   lib-y += memcpy_$(BITS).o
> -lib-y += insn.o inat.o
> +lib-$(CONFIG_KPROBES) += insn.o inat.o
>
>   obj-y += msr-reg.o msr-reg-export.o
>
> diff -puN arch/x86/Kconfig.debug~kconfig-decoder-only-for-kprobe arch/x86/Kconfig.debug
> --- linux-2.6/arch/x86/Kconfig.debug~kconfig-decoder-only-for-kprobe	2009-12-06 19:49:06.000000000 +0900
> +++ linux-2.6-hirofumi/arch/x86/Kconfig.debug	2009-12-06 19:49:06.000000000 +0900
> @@ -187,8 +187,8 @@ config HAVE_MMIOTRACE_SUPPORT
>   	def_bool y
>
>   config X86_DECODER_SELFTEST
> -     bool "x86 instruction decoder selftest"
> -     depends on DEBUG_KERNEL
> +	bool "x86 instruction decoder selftest"
> +	depends on DEBUG_KERNEL&&  KPROBES
>   	---help---
>   	 Perform x86 instruction decoder selftests at build time.
>   	 This option is useful for checking the sanity of x86 instruction
> _
>

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

