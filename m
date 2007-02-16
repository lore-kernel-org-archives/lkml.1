Return-Path: <linux-kernel-owner+w=401wt.eu-S1946215AbXBPSnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946215AbXBPSnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 13:43:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946216AbXBPSnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 13:43:51 -0500
Received: from smtp.osdl.org ([65.172.181.24]:57971 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946215AbXBPSnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 13:43:50 -0500
Date: Fri, 16 Feb 2007 10:43:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Tilman Schmidt <tilman@imap.cc>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Move include linux/marker.h to kernel.h
Message-Id: <20070216104340.3c6f2eed.akpm@linux-foundation.org>
In-Reply-To: <20070216180513.GC14004@Krystal>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
	<45D483D7.2040609@imap.cc>
	<20070215144142.0c13580a.akpm@linux-foundation.org>
	<20070215224656.GB6297@Krystal>
	<20070215154418.88edfcbc.akpm@linux-foundation.org>
	<20070216003739.GC9851@Krystal>
	<20070215172242.ab7a6f1e.akpm@linux-foundation.org>
	<20070216180513.GC14004@Krystal>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007 13:05:13 -0500 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Move include linux/marker.h to kernel.h
> 
> * Andrew Morton (akpm@linux-foundation.org) wrote:
> > Oh.  One could whack [include linux/marker.h] in kernel.h: pretty
> > much everything includes that.
> > 
> > But it'd be better to simply require that the clients of this
> > infrastructure include the appropriate header file.  We do that for
> > everything else and markers aren't special in this regard.
> 
> It seems like the logical solution. This patch moves this include from
> Makefile to include/linux/kernel.h.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 
> --- a/Makefile
> +++ b/Makefile
> @@ -308,9 +308,7 @@ AFLAGS_KERNEL	=
>  # Needed to be compatible with the O= option
>  LINUXINCLUDE    := -Iinclude \
>                     $(if $(KBUILD_SRC),-Iinclude2 -I$(srctree)/include) \
> -		   -include include/linux/autoconf.h \
> -		   -include \
> -		   	$(if $(KBUILD_SRC),$(srctree)/)include/linux/marker.h
> +		   -include include/linux/autoconf.h
>  
>  CPPFLAGS        := -D__KERNEL__ $(LINUXINCLUDE)
>  
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -14,6 +14,7 @@
>  #include <linux/compiler.h>
>  #include <linux/bitops.h>
>  #include <linux/log2.h>
> +#include <linux/marker.h>
>  #include <asm/byteorder.h>
>  #include <asm/bug.h>

No, that's still crufty.  There's no reason why marker.h needs special
treatment whereas, say, jiffies.h does not (is there?)

It is conventional and reasonable to require that any code which uses this
mechanism must include its header file.

