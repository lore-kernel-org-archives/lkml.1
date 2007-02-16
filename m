Return-Path: <linux-kernel-owner+w=401wt.eu-S1422912AbXBPAk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422912AbXBPAk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 19:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422913AbXBPAk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 19:40:27 -0500
Received: from smtp.osdl.org ([65.172.181.24]:40511 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422912AbXBPAk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 19:40:26 -0500
Date: Thu, 15 Feb 2007 16:37:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Tilman Schmidt <tilman@imap.cc>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparse chokes on arch/i386/kernel/i8253.c
Message-Id: <20070215163709.720c38f0.akpm@linux-foundation.org>
In-Reply-To: <20070216002347.GB9851@Krystal>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
	<45D483D7.2040609@imap.cc>
	<20070215144142.0c13580a.akpm@linux-foundation.org>
	<20070216002347.GB9851@Krystal>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 19:23:47 -0500
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> sparse chokes on arch/i386/kernel/i8253.c
> 
> Here is a marker fix that puts the correct -i include/linux/marker.h in
> the top level Makefile so sparse works correctly. The tricky part is to
> keep the kernel compiling correctly with a kernel build directory
> different from the kernel source tree too.
> 
> The fix applies on top the the Linux Kernel Markers for 2.6.20.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 
> --- a/Makefile
> +++ b/Makefile
> @@ -309,7 +309,8 @@ AFLAGS_KERNEL	=
>  LINUXINCLUDE    := -Iinclude \
>                     $(if $(KBUILD_SRC),-Iinclude2 -I$(srctree)/include) \
>  		   -include include/linux/autoconf.h \
> -		   -include linux/marker.h
> +		   -include \
> +		   	$(if $(KBUILD_SRC),$(srctree)/)include/linux/marker.h
>  
>  CPPFLAGS        := -D__KERNEL__ $(LINUXINCLUDE)

But what is so magical about marker.h to justify special-case treatment at the
kbuid level?
