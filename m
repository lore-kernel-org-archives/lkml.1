Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbYAAKPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbYAAKPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 05:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbYAAKPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 05:15:42 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:60574 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbYAAKPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 05:15:41 -0500
Date: Tue, 1 Jan 2008 11:15:40 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       linux-mips@linux-mips.org
Subject: Re: [Patch 2/8] MIPS: Remove 'TOPDIR' from Makefiles
Message-ID: <20080101101540.GB28913@uranus.ravnborg.org>
References: <20080101071311.GA2496@hacking> <20080101072238.GC2496@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101072238.GC2496@hacking>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 03:22:38PM +0800, WANG Cong wrote:
> 
> TOPDIR is obsolete, use objtree instead.
> This patch removes TOPDIR from all Mips Makefiles.
> 
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
> ---
> 
> diff --git a/arch/mips/lasat/image/Makefile b/arch/mips/lasat/image/Makefile
> index 5332449..5196962 100644
> --- a/arch/mips/lasat/image/Makefile
> +++ b/arch/mips/lasat/image/Makefile
> @@ -12,7 +12,7 @@ endif
>  
>  MKLASATIMG = mklasatimg
>  MKLASATIMG_ARCH = mq2,mqpro,sp100,sp200
> -KERNEL_IMAGE = $(TOPDIR)/vmlinux
> +KERNEL_IMAGE = $(objtree)/vmlinux

Current directory when building is $(objtree) so here we should
just skip the use of TOPDIR like this:
> +KERNEL_IMAGE = vmlinux


>  KERNEL_START = $(shell $(NM) $(KERNEL_IMAGE) | grep " _text" | cut -f1 -d\ )
>  KERNEL_ENTRY = $(shell $(NM) $(KERNEL_IMAGE) | grep kernel_entry | cut -f1 -d\ )
>  
> @@ -24,7 +24,7 @@ HEAD_DEFINES := -D_kernel_start=0x$(KERNEL_START) \
>  		-D TIMESTAMP=$(shell date +%s)
>  
>  $(obj)/head.o: $(obj)/head.S $(KERNEL_IMAGE)
> -	$(CC) -fno-pic $(HEAD_DEFINES) -I$(TOPDIR)/include -c -o $@ $<
> +	$(CC) -fno-pic $(HEAD_DEFINES) -I$(objtree)/include -c -o $@ $<
This has never worked with O=.. builds.
The correct fix here is to use:
> +	$(CC) -fno-pic $(HEAD_DEFINES) -Iinclude -Iinclude2 -c -o $@ $<

The -Iinclude2 is only for O=... builds so to keep current
behaviour removing $(TOPDIR)/ would do it.

	Sam
