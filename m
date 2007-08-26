Return-Path: <linux-kernel-owner+w=401wt.eu-S1753626AbXHZXwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbXHZXwi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 19:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbXHZXw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 19:52:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45063 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbXHZXw2 (ORCPT
	<rfc822;Linux-Kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 19:52:28 -0400
Message-ID: <46D2122D.2050202@zytor.com>
Date: Sun, 26 Aug 2007 16:52:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Denis Cheng <crquan@gmail.com>
CC: Linux-Kernel@vger.kernel.org, cr_quan@163.com
Subject: Re: [PATCH] [arch/i386/boot]: for better readability in clearing
 BSS
References: <11880356722224-git-send-email-crquan@gmail.com>
In-Reply-To: <11880356722224-git-send-email-crquan@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Cheng wrote:
> 
> but their label names in .bss section are different,
> when reading these files, they are apt to confuse,
> 
> this patch kept them in the same style of clearing.
> 

Bullsh*t.

> diff --git a/arch/i386/boot/compressed/head.S b/arch/i386/boot/compressed/head.S
> index f35ea22..e499db0 100644
> --- a/arch/i386/boot/compressed/head.S
> +++ b/arch/i386/boot/compressed/head.S
> @@ -113,7 +113,7 @@ relocated:
>   * Clear BSS
>   */
>  	xorl %eax,%eax
> -	leal _edata(%ebx),%edi
> +	leal _bss(%ebx),%edi
>  	leal _end(%ebx), %ecx
>  	subl %edi,%ecx
>  	cld

Here you change _edata.._end into _bss.._end.

> diff --git a/arch/i386/boot/header.S b/arch/i386/boot/header.S
> index 7f4a2c5..cd074c1 100644
> --- a/arch/i386/boot/header.S
> +++ b/arch/i386/boot/header.S
> @@ -254,7 +254,7 @@ setup2:
>  
>  # Zero the bss
>  	movw	$__bss_start, %di
> -	movw	$_end+3, %cx
> +	movw	$__bss_end, %cx
>  	xorl	%eax, %eax
>  	subw	%di, %cx
>  	shrw	$2, %cx

Here you change __bss_start..to __bss_end, and have to change the linker
script for it not to break.

There is no consistency improvement, and as such, it's just churn.

	-hpa
