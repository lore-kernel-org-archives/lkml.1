Return-Path: <linux-kernel-owner+w=401wt.eu-S934129AbXF2S27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934129AbXF2S27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 14:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754755AbXF2S2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 14:28:52 -0400
Received: from terminus.zytor.com ([192.83.249.54]:36615 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbXF2S2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 14:28:51 -0400
Message-ID: <46854F2D.9080604@zytor.com>
Date: Fri, 29 Jun 2007 14:27:57 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: "H. J. Lu" <hjl@lucon.org>
CC: joerg.roedel@amd.com, linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: PATCH: Fix SVM MSR indexes for 32bit kernel
References: <20070629153815.GA18297@lucon.org>
In-Reply-To: <20070629153815.GA18297@lucon.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. J. Lu wrote:
> }
> [hjl@gnu-5 tmp]$ gcc -m32 -S foo.c
> foo.c: In function â_disabledâfoo.c:7: error: impossible register
> constraint in âmâoo.c:12: confused by earlier errors, bailing out
> [hjl@gnu-5 tmp]$
> 
> on 32bit. This patch removes the ULL suffix in SVM MSR indexes.
> 
> 
> H.J.
> --- linux-2.6.21.i686/drivers/kvm/svm.h.msr	2007-06-28 22:42:12.000000000 -0700
> +++ linux-2.6.21.i686/drivers/kvm/svm.h	2007-06-29 08:03:09.000000000 -0700
> @@ -175,8 +175,8 @@ struct __attribute__ ((__packed__)) vmcb
>  #define SVM_CPUID_FUNC 0x8000000a
>  
>  #define MSR_EFER_SVME_MASK (1ULL << 12)
> -#define MSR_VM_CR       0xc0010114ULL
> -#define MSR_VM_HSAVE_PA 0xc0010117ULL
> +#define MSR_VM_CR       0xc0010114
> +#define MSR_VM_HSAVE_PA 0xc0010117
>  

Please take the MSR indicies out of this file and move them to 
include/asm-i386/msr-index.h.

	-hpa

