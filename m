Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbXFLWEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbXFLWEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 18:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbXFLWE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 18:04:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56726 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752703AbXFLWE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 18:04:27 -0400
Date: Tue, 12 Jun 2007 15:03:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: Adrian Bunk <bunk@stusta.de>, avi@qumranet.com,
       linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: Re: 2.6.22-rc4-mm2: kvm compile breakage with X86_CMPXCHG64=n
Message-Id: <20070612150357.1685c622.akpm@linux-foundation.org>
In-Reply-To: <20070612032224.GA19293@redhat.com>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
	<20070612000718.GS3588@stusta.de>
	<20070612032224.GA19293@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2007 23:22:24 -0400
Dave Jones <davej@redhat.com> wrote:

> Add -Werror-implicit-function-declaration
> This makes builds fail sooner if something is implicitly defined instead
> of having to wait half an hour for it to fail at the linking stage.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> --- linux-2.6/Makefile~	2007-06-04 16:46:24.000000000 -0400
> +++ linux-2.6/Makefile	2007-06-04 16:46:53.000000000 -0400
> @@ -313,7 +313,8 @@ LINUXINCLUDE    := -Iinclude \
>  CPPFLAGS        := -D__KERNEL__ $(LINUXINCLUDE)
>  
>  CFLAGS          := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
> -                   -fno-strict-aliasing -fno-common
> +		   -fno-strict-aliasing -fno-common \
> +		   -Werror-implicit-function-declaration
>  AFLAGS          := -D__ASSEMBLY__
>  
>  # Read KERNELRELEASE from include/config/kernel.release (if it exists)

This causes the i386 allmodconfig build to fail:

include/linux/uaccess.h: In function 'pagefault_disable':
include/linux/uaccess.h:23: error: implicit declaration of function '__memory_barrier'

I didn't look to see why...
