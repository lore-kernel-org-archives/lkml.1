Return-Path: <linux-kernel-owner+w=401wt.eu-S1753233AbXFKQRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbXFKQRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 12:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbXFKQQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 12:16:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39127 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751597AbXFKQQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 12:16:48 -0400
Date: Mon, 11 Jun 2007 09:15:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Steve Fox <drfickle@us.ibm.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] move the kernel to 16MB for NUMA-Q
Message-Id: <20070611091558.f468f205.akpm@linux-foundation.org>
In-Reply-To: <63a08cc7547f14065becdf9a94d0d529@pinky>
References: <466D550C.4030600@shadowen.org>
	<63a08cc7547f14065becdf9a94d0d529@pinky>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2007 15:32:10 +0100 Andy Whitcroft <apw@shadowen.org> wrote:

> 
> We are seeing corruption of the decompressed kernel.  It is suspected
> that this is platform specific as it has yet to be seen on any
> other x86.  Move the kernel to the 16MB boundary.
> 
> Signed-off-by: Andy Whitcroft <apw@shadowen.org>
> ---
> diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
> index 7e1950f..89e6bf4 100644
> --- a/arch/i386/Kconfig
> +++ b/arch/i386/Kconfig
> @@ -817,6 +817,7 @@ config CRASH_DUMP
>  
>  config PHYSICAL_START
>  	hex "Physical address where the kernel is loaded" if (EMBEDDED || CRASH_DUMP)
> +	default "0x1000000" if X86_NUMAQ
>  	default "0x100000"
>  	help
>  	  This gives the physical address where the kernel is loaded.

grumble.  If it's a BIOS bug then OK.  But if it is indeed a kernel bug
then this patch didn't make it go away and it shall return to haunt us.

Oh well.  Let's hope that the bug (if it is such) will turn up on something
which is less debugging-hostile than a NUMAQ.

