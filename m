Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759313AbYLQHZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313AbYLQHZJ (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 02:25:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbYLQHYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 02:24:55 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:38236 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbYLQHYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 02:24:54 -0500
Date: Wed, 17 Dec 2008 08:26:20 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] get rid of the last symlink in uml build
Message-ID: <20081217072620.GA3551@uranus.ravnborg.org>
References: <20081217061250.GX28946@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217061250.GX28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 06:12:50AM +0000, Al Viro wrote:
> 	We need to make asm-offsets.h contents visible for objects built
> with userland headers.  Instead of creating a symlink, just have the
> file with equivalent include (relative to location of header) created
> once.
> 
> 	That kills the last symlink used in arch/um builds.  Have fun...

great!
Soon we have no more symlinks generated for a kernel build.
um used to be the worst of all but you have fixed it all up now.

Minor comment below.

Thanks,
	Sam
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> diff --git a/arch/um/Makefile b/arch/um/Makefile
> index d944c34..3fd7e45 100644
> --- a/arch/um/Makefile
> +++ b/arch/um/Makefile
> @@ -22,10 +22,11 @@ MODE_INCLUDE	+= -I$(srctree)/$(ARCH_DIR)/include/shared/skas
>  
>  include $(srctree)/$(ARCH_DIR)/Makefile-skas
>  
> -ARCH_INCLUDE	:= -I$(srctree)/$(ARCH_DIR)/include/shared
> +SHARED_HEADERS	:= $(ARCH_DIR)/include/shared
> +ARCH_INCLUDE	:= -I$(srctree)/$(SHARED_HEADERS)
>  ARCH_INCLUDE	+= -I$(srctree)/$(ARCH_DIR)/sys-$(SUBARCH)/shared
>  ifneq ($(KBUILD_SRC),)
> -ARCH_INCLUDE	+= -I$(ARCH_DIR)/include/shared # for two generated files
> +ARCH_INCLUDE	+= -I$(SHARED_HEADERS)
>  endif
>  KBUILD_CPPFLAGS += -I$(srctree)/$(ARCH_DIR)/sys-$(SUBARCH)
>  
> @@ -85,8 +86,8 @@ endef
>  
>  KBUILD_KCONFIG := arch/um/Kconfig.$(HEADER_ARCH)
>  
> -archprepare: $(ARCH_DIR)/include/shared/user_constants.h
> -prepare: $(ARCH_DIR)/include/shared/kern_constants.h
> +archprepare: $(SHARED_HEADERS)/user_constants.h
> +prepare: $(SHARED_HEADERS)/kern_constants.h

arch Makefiles should rely solely on the archprepare target.
That cleanup could come later as it is independent from
the purpose of this patch.

	Sam
