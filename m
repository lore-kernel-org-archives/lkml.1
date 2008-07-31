Return-Path: <linux-kernel-owner+w=401wt.eu-S1756131AbYGaUQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbYGaUQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 16:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbYGaUQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 16:16:14 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:30064 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbYGaUQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 16:16:14 -0400
Date: Thu, 31 Jul 2008 22:16:02 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, jdike@addtoit.com,
       linux-kbuild@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [Patch] UML build: fix missing posix_types.h
Message-ID: <20080731201602.GC25158@uranus.ravnborg.org>
References: <20080731121028.GA23636@hack.voiplan.pt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080731121028.GA23636@hack.voiplan.pt>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 01:10:28PM +0100, WANG Cong wrote:
> 
> When building UML with 'O=foo' specified, I got:
> 
> CC      kernel/bounds.s
>   In file included from
> /home/wangcong/Projects/linux-2.6/include/linux/types.h:11,
>                  from
> /home/wangcong/Projects/linux-2.6/include/linux/page-flags.h:8,
>                  from
> /home/wangcong/Projects/linux-2.6/kernel/bounds.c:9:
> /home/wangcong/Projects/linux-2.6/include/linux/posix_types.h:47:29:
> error: asm/posix_types.h: No such file or directory
> In file included from
> /home/wangcong/Projects/linux-2.6/include/linux/page-flags.h:8,
>                  from
> /home/wangcong/Projects/linux-2.6/kernel/bounds.c:9:
> /home/wangcong/Projects/linux-2.6/include/linux/types.h:12:23: error:
> asm/types.h: No such file or directory
> In file included from
> /home/wangcong/Projects/linux-2.6/include/linux/page-flags.h:8,
> 
> Below patch fixed it, note, it is only tested for x86 and um.
> 
> Signed-off-by: WANG Cong <wangcong@zeuux.org>
> Cc: sam@ravnborg.org
> Cc: jdike@addtoit.com
> 
> ---
> diff --git a/Makefile b/Makefile
> index aa527a4..39130d1 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -930,7 +930,8 @@ ifneq ($(KBUILD_SRC),)
>  		/bin/false; \
>  	fi;
>  	$(Q)if [ ! -d include2 ]; then mkdir -p include2; fi;
> -	$(Q)if [ -e $(srctree)/include/asm-$(SRCARCH)/system.h ]; then  \
> +	$(Q)if [ -e $(srctree)/include/asm-$(SRCARCH)/system.h -o \
> +		 -e $(objtree)/include/asm-$(SRCARCH)/system.h ] ; then \
>  	    ln -fsn $(srctree)/include/asm-$(SRCARCH) include2/asm;     \
>  	    fi
>  endif

I have a similar patch locally. I just check for errno.h so I 
do not have to do the extra check in objtree.
Will push tonight.

	Sam
