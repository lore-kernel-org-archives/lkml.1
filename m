Return-Path: <linux-kernel-owner+w=401wt.eu-S1758942AbZCOVXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942AbZCOVXG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 17:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754413AbZCOVWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 17:22:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49655 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbZCOVWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 17:22:53 -0400
Message-ID: <49BD70B3.3030703@zytor.com>
Date: Sun, 15 Mar 2009 14:18:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 12/24] x86-64: remove PGE from must-have feature list
References: <1236931920-6861-1-git-send-email-jeremy@goop.org> <1236931920-6861-13-git-send-email-jeremy@goop.org>
In-Reply-To: <1236931920-6861-13-git-send-email-jeremy@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> PGE may not be available when running paravirtualized, so test the cpuid
> bit before using it.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  arch/x86/include/asm/required-features.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/include/asm/required-features.h b/arch/x86/include/asm/required-features.h
> index d5cd6c5..a4737dd 100644
> --- a/arch/x86/include/asm/required-features.h
> +++ b/arch/x86/include/asm/required-features.h
> @@ -50,7 +50,7 @@
>  #ifdef CONFIG_X86_64
>  #define NEED_PSE	0
>  #define NEED_MSR	(1<<(X86_FEATURE_MSR & 31))
> -#define NEED_PGE	(1<<(X86_FEATURE_PGE & 31))
> +#define NEED_PGE	0
>  #define NEED_FXSR	(1<<(X86_FEATURE_FXSR & 31))
>  #define NEED_XMM	(1<<(X86_FEATURE_XMM & 31))
>  #define NEED_XMM2	(1<<(X86_FEATURE_XMM2 & 31))

This should be conditionalized on CONFIG_PARAVIRT, since doing this
removes real-hardware optimimizations.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

