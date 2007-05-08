Return-Path: <linux-kernel-owner+w=401wt.eu-S966456AbXEHK3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966456AbXEHK3H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 06:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934891AbXEHK3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 06:29:01 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934735AbXEHK3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 06:29:00 -0400
Date: Tue, 8 May 2007 03:28:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Andi Kleen <ak@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make bootsector stub 16-bit-only (i386)
Message-Id: <20070508032817.e4734798.akpm@linux-foundation.org>
In-Reply-To: <20070505104452.GA30944@mailshack.com>
References: <20070505104452.GA30944@mailshack.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 May 2007 12:44:52 +0200 Alexander van Heukelum <heukelum@mailshack.com> wrote:

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

Sigh, another blow struck in the ongoing struggle between my Vaio and the
rest of the world.

Stone-cold black-screen lockup immediately upon boot.

Stock FC5 install, config at
http://userweb.kernel.org/~akpm/config-sony.txt
