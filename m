Return-Path: <linux-kernel-owner+w=401wt.eu-S934253AbXEESI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934253AbXEESI2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 14:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934252AbXEESI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 14:08:28 -0400
Received: from terminus.zytor.com ([192.83.249.54]:56283 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934253AbXEESIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 14:08:23 -0400
Message-ID: <463CC7FD.6090006@zytor.com>
Date: Sat, 05 May 2007 11:07:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@mailshack.com>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make bootsector stub 16-bit-only (i386)
References: <20070505104452.GA30944@mailshack.com>
In-Reply-To: <20070505104452.GA30944@mailshack.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: H. Peter Anvin <hpa@zytor.com>

Alexander van Heukelum wrote:
> Hi!
> 
> The x86 bzImage contains a stub to inform people that it is not possible
> any more to run a Linux kernel by catting it to a floppy and then
> booting from it. This was meant to be all 16-bit code. The first
> instruction, however, ended up as being coded as a 16:32-bit far jump. I
> assume the intention was a 16:16-bit far jump.
> 
> This patch changes only i386.
> 
> Greetings,
> 	Alexander
> 
> Signed-off-by: Alexander van Heukelum <heukelum@mailshack.com>
> 
> ---
> 
> diff --git a/arch/i386/boot/bootsect.S b/arch/i386/boot/bootsect.S
> index 011b7a4..ae9df0d 100644
> --- a/arch/i386/boot/bootsect.S
> +++ b/arch/i386/boot/bootsect.S
> @@ -44,7 +44,7 @@ #endif
>  _start:
>  
>  	# Normalize the start address
> -	jmpl	$BOOTSEG, $start2
> +	jmpw	$BOOTSEG, $start2
>  
>  start2:
>  	movw	%cs, %ax
