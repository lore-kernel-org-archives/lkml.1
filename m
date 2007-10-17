Return-Path: <linux-kernel-owner+w=401wt.eu-S933742AbXJQUJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933742AbXJQUJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933413AbXJQUJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:09:38 -0400
Received: from www.tglx.de ([62.245.132.106]:34114 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933370AbXJQUJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:09:37 -0400
Date: Wed, 17 Oct 2007 22:09:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: delete vsyscall files during make clean
In-Reply-To: <20071017200630.GH11837@uranus.ravnborg.org>
Message-ID: <alpine.LFD.0.9999.0710172209030.24155@localhost.localdomain>
References: <1192164538.10413.3.camel@Homer.simpson.net> <20071012213114.GA24016@uranus.ravnborg.org> <1192246457.7395.19.camel@Homer.simpson.net> <47105A39.9070406@debian.org> <20071013071626.GA28168@uranus.ravnborg.org> <1192260909.7369.20.camel@Homer.simpson.net>
 <20071013081759.GB28168@uranus.ravnborg.org> <1192608832.30373.5.camel@Homer.simpson.net> <20071017200630.GH11837@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007, Sam Ravnborg wrote:
> make clean failed to delete a few files in
> x86/kernel. This is because kbuild does not
> see the correct/full kernel/Makefile.
> 
> As a workaround until the Makefiles are merged specify
> the files to be deleted in the common Makefile.
> 
> Reported by Mike Galbraith <efault@gmx.de>
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Mike Galbraith <efault@gmx.de>
> ---
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index 45855c9..3857334 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -3,3 +3,7 @@ include ${srctree}/arch/x86/kernel/Makefile_32
>  else
>  include ${srctree}/arch/x86/kernel/Makefile_64
>  endif
> +
> +# Workaround to delete .lds files with make clean
> +# The problem is that we do not enter Makefile_32 with make clean.
> +clean-files := vsyscall*.lds vsyscall*.so

Thanks applied,

	 tglx

