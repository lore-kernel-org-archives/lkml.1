Return-Path: <linux-kernel-owner+w=401wt.eu-S1758463AbYARFIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463AbYARFIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 00:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbYARFIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 00:08:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52824 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbYARFIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 00:08:06 -0500
Message-ID: <479032CD.9040306@zytor.com>
Date: Fri, 18 Jan 2008 00:02:05 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] x86: merge asm-x86/alternative.h
References: <20080118050336.GC974@phobos.i.cabal.ca>
In-Reply-To: <20080118050336.GC974@phobos.i.cabal.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle McMartin wrote:
> Straightforward merge. Kind of a pity that gas doesn't really have the
> concept of a "long" (long is 4-bytes for some reason.) Nor is it able to
> pad to a non-power of two boundary (for struct alignment) to get rid
> of the struct alt_instr padding.
> 
> Build tested on i386, i386 with lguest & xen paravirt enabled, and
> x86_64. Boot tested on x86_64.
> 
> 
> diff --git a/include/asm-x86/alternative.h b/include/asm-x86/alternative.h
> index 9eef6a3..7047a0f 100644
> --- a/include/asm-x86/alternative.h
> +++ b/include/asm-x86/alternative.h
> @@ -1,5 +1,168 @@
> -#ifdef CONFIG_X86_32
> -# include "alternative_32.h"
> +#ifndef _X86_ALTERNATIVE_H
> +#define _X86_ALTERNATIVE_H
> +
> +#ifdef __KERNEL__
> +
> +#include <linux/types.h>
> +#include <linux/stddef.h>
> +
> +#ifdef CONFIG_X86_64
> +# define ALT_ASMPTR	".quad"
> +# define ALT_ALIGN	"8"
> +# define ALT_INSTR_PAD	5
>  #else
> -# include "alternative_64.h"
> +# define ALT_ASMPTR	".long"
> +# define ALT_ALIGN	"4"
> +# define ALT_INSTR_PAD	1
>  #endif

Please use existing macros from <asm/asm.h> (in the x86 tree.)

	-hpa
