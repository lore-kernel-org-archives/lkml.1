Return-Path: <linux-kernel-owner+w=401wt.eu-S1752099AbXB0U0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbXB0U0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 15:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbXB0U0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 15:26:20 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50392 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbXB0U0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 15:26:09 -0500
Date: Tue, 27 Feb 2007 12:25:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-mm2
Message-Id: <20070227122551.7f3143a8.akpm@linux-foundation.org>
In-Reply-To: <20070225141530.ba99c357.khali@linux-fr.org>
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
	<20070225141530.ba99c357.khali@linux-fr.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 25 Feb 2007 14:15:30 +0100 Jean Delvare <khali@linux-fr.org> wrote:
> Hi Andrew, all,
> 
> I appear to need the following fix to be able to build 2.6.20-mm2 on
> x86_64. Without the fix, my build attempt dies on:
> 
> In file included from drivers/pci/quirks.c:532:
> include/asm/io_apic.h:61: error: "MAX_IO_APICS" undeclared here (not in a function)
> 
> Not sure how nobody else was bitten by this one yet... i386 seems to
> need the same so I've fixed it as well.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> ---
>  include/asm-i386/io_apic.h   |    1 +
>  include/asm-x86_64/io_apic.h |    1 +
>  2 files changed, 2 insertions(+)
> 
> --- linux-2.6.20.orig/include/asm-i386/io_apic.h	2007-02-25 13:01:40.000000000 +0100
> +++ linux-2.6.20/include/asm-i386/io_apic.h	2007-02-25 14:01:33.000000000 +0100
> @@ -3,6 +3,7 @@
>  
>  #include <asm/types.h>
>  #include <asm/mpspec.h>
> +#include <asm/apicdef.h>
>  
>  /*
>   * Intel IO-APIC support for SMP and UP systems.
> --- linux-2.6.20.orig/include/asm-x86_64/io_apic.h	2007-02-25 13:01:43.000000000 +0100
> +++ linux-2.6.20/include/asm-x86_64/io_apic.h	2007-02-25 13:54:31.000000000 +0100
> @@ -3,6 +3,7 @@
>  
>  #include <asm/types.h>
>  #include <asm/mpspec.h>
> +#include <asm/apicdef.h>
>  
>  /*
>   * Intel IO-APIC support for SMP and UP systems.
> 

erk.

My problem is that I need to work out which patch in -mm broke the build so
that I can insert this patch in the appropriate position.

Can you please send the offending .config so I can do that?

Thanks.

