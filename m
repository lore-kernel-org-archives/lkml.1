Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbZCLEai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbZCLEai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 00:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbZCLEa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 00:30:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37243 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbZCLEa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 00:30:28 -0400
Message-ID: <49B88F80.3080203@zytor.com>
Date: Wed, 11 Mar 2009 21:28:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: relocs is only used with 32bit
References: <49B80F7B.2020007@kernel.org>
In-Reply-To: <49B80F7B.2020007@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,

In general I prefer minimizing the conditional sections rather than
maximizing them.  If nothing else, it catches errors earlier that way,
and makes it easier to eventually eliminate them entirely.

	-hpa

Yinghai Lu wrote:
> Impact: cleanup
> 
> those lines is not needed for 64bit
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/boot/compressed/Makefile |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> Index: linux-2.6/arch/x86/boot/compressed/Makefile
> ===================================================================
> --- linux-2.6.orig/arch/x86/boot/compressed/Makefile
> +++ linux-2.6/arch/x86/boot/compressed/Makefile
> @@ -26,6 +26,7 @@ OBJCOPYFLAGS_vmlinux.bin :=  -R .comment
>  $(obj)/vmlinux.bin: vmlinux FORCE
>  	$(call if_changed,objcopy)
>  
> +ifeq ($(CONFIG_X86_32),y)
>  
>  targets += vmlinux.bin.all vmlinux.relocs relocs
>  hostprogs-$(CONFIG_X86_32) += relocs
> @@ -42,8 +43,6 @@ quiet_cmd_relocbin = BUILD   $@
>  $(obj)/vmlinux.bin.all: $(vmlinux.bin.all-y) FORCE
>  	$(call if_changed,relocbin)
>  
> -ifeq ($(CONFIG_X86_32),y)
> -
>  ifdef CONFIG_RELOCATABLE
>  $(obj)/vmlinux.bin.gz: $(obj)/vmlinux.bin.all FORCE
>  	$(call if_changed,gzip)


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

