Return-Path: <linux-kernel-owner+w=401wt.eu-S1757476AbXHOM3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbXHOM3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 08:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbXHOM3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 08:29:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52388 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbXHOM3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 08:29:36 -0400
Message-ID: <46C2F19A.30003@anagramm.de>
Date: Wed, 15 Aug 2007 14:29:14 +0200
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: patches@x86-64.org, linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [PATCH] [3/4] x86_64: Change PMDS invocation to single macro
References: <20070815240.194452000@suse.de> <20070815004036.6BBCF14DC8@wotan.suse.de>
In-Reply-To: <20070815004036.6BBCF14DC8@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+CmMFJ+jf2IjEPcu2EnxBHg5BowIv2QucIgf3
 tYw9De4je5AE4WvfTzzPHOIAdu5oLzBgjcr2GwSrLJDCo06KAd
 9jLJknKrynU+MIIjbAI4g==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen schrieb:
> Very old binutils (2.12.90...) seem to have trouble with newlines
> in assembler macro invocation. They put them into the resulting
> argument expansion. In this case this lead to a parse error because
> a .rept expression ended up spread over multiple lines. Change the PMDS() 
> invocation to a single line.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> Index: linux/arch/x86_64/kernel/head.S
> ===================================================================
> --- linux.orig/arch/x86_64/kernel/head.S
> +++ linux/arch/x86_64/kernel/head.S
> @@ -345,8 +345,7 @@ NEXT_PAGE(level2_kernel_pgt)
>  	/* 40MB kernel mapping. The kernel code cannot be bigger than that.
>  	   When you change this change KERNEL_TEXT_SIZE in page.h too. */
>  	/* (2^48-(2*1024*1024*1024)-((2^39)*511)-((2^30)*510)) = 0 */
> -	PMDS(0x0000000000000000, __PAGE_KERNEL_LARGE_EXEC|_PAGE_GLOBAL,
> -		KERNEL_TEXT_SIZE/PMD_SIZE)
> +	PMDS(0x0000000000000000, __PAGE_KERNEL_LARGE_EXEC|_PAGE_GLOBAL, KERNEL_TEXT_SIZE/PMD_SIZE)

Can you please add a comment, that this line must stay in a single line
for the above reason? I would expect that the next who does some code
clean up will break it again.

>  	/* Module mapping starts here */
>  	.fill	(PTRS_PER_PMD - (KERNEL_TEXT_SIZE/PMD_SIZE)),8,0

Regards,
-- 
Clemens Koller
_______________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Str. 45/1
81379 Muenchen
Germany

http://www.anagramm-technology.com
Phone: +49-89-741518-50
Fax: +49-89-741518-19
