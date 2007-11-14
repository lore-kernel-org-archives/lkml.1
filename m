Return-Path: <linux-kernel-owner+w=401wt.eu-S1762281AbXKNAvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762281AbXKNAvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 19:51:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759409AbXKNAu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 19:50:59 -0500
Received: from nessie.weebeastie.net ([220.233.7.36]:60637 "EHLO
	bunyip.lochness.weebeastie.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754450AbXKNAu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 19:50:58 -0500
Date: Wed, 14 Nov 2007 11:21:07 +1100
From: CaT <cat@zip.com.au>
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [13/45] x86_64: Increase VDSO_TEXT_OFFSET for ancient binutils
Message-ID: <20071114002107.GA24395@zip.com.au>
References: <200709211044.901175000@suse.de> <20070921204454.B51F714EFF@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921204454.B51F714EFF@wotan.suse.de>
Organisation: Furball Inc.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 10:44:54PM +0200, Andi Kleen wrote:
> For some reason old binutils genertate larger headers so
> increase the text offset of the vdso to avoid linker errors.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  arch/x86_64/vdso/voffset.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux/arch/x86_64/vdso/voffset.h
> ===================================================================
> --- linux.orig/arch/x86_64/vdso/voffset.h
> +++ linux/arch/x86_64/vdso/voffset.h
> @@ -1 +1 @@
> -#define VDSO_TEXT_OFFSET 0x500
> +#define VDSO_TEXT_OFFSET 0x600

This still breaks under Debian sarge. There is this (german) forum
thread about it:

http://www.debianforum.de/forum/viewtopic.php?p=570102

Robotic english translation:
http://translate.google.com/translate?u=http%3A%2F%2Fwww.debianforum.de%2Fforum%2Fviewtopic.php%3Fp%3D569756%26sid%3D20278bfd231c5dac45fa0f2763c7ec54%23569756&langpair=de%7Cen&hl=en&ie=UTF-8

And it indicates that 0x510 would be the better offset due to 0x600
making it clash with the data section beneath. Indeed when I change it
to 0x510 I can compile the kernel with binutils 2.15-6.

I'm hoping this wont cause the kernel to eat my grandma. :)

-- 
    "To the extent that we overreact, we proffer the terrorists the
    greatest tribute."
    	- High Court Judge Michael Kirby
