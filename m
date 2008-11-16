Return-Path: <linux-kernel-owner+w=401wt.eu-S1752291AbYKPHsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbYKPHsi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 02:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbYKPHs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 02:48:29 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:34636 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbYKPHs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 02:48:28 -0500
Date: Sun, 16 Nov 2008 08:49:48 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: viro@ZenIV.linux.org.uk, zippel@linux-m68k.org,
       linux-kernel@vger.kernel.org
Subject: Re: Immortal CONFIG_DEBUG_INFO=y
Message-ID: <20081116074948.GA32670@uranus.ravnborg.org>
References: <20081116074201.GA27921@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081116074201.GA27921@x200.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2008 at 10:42:01AM +0300, Alexey Dobriyan wrote:
> As known to everybody doing fat builds, banning DEBUG_INFO=y is mandatory,
> otherwise build is slower and takes much more disk space. And to not
> accidently enable it, banning it in kconfig:
> 
> 	@@ -475,7 +475,7 @@ config DEBUG_BUGVERBOSE
> 	 
> 	 config DEBUG_INFO
> 	 	bool "Compile the kernel with debug info"
> 	-	depends on DEBUG_KERNEL
> 	+	depends on DEBUG_KERNEL && DISABLED
> 	 	help
> 	           If you say Y here the resulting kernel image will include
> 	 	  debugging info resulting in a larger kernel image.
> 
> This works pretty well -- allmodconfig generates config without DEBUG_INFO and
> so on, defconfigs also regenerated without it, even if original one in arch/
> has DEBUG_INFO enabled and so on. Trick also works for other options, like,
> KALLSYMS_EXTRA_PASS.
> 
> Except one case:
> 
> 	make ARCH=sh magicpanelr2_defconfig
> 
> DEBUG_INFO survives to .config and resulting build runs with -g.

Because that defconfig does:
CONFIG_SH_KGDB=y

and SH_KGDB does:
	select DEBUG_INFO

Instead of editing the Kconfig file you should use the KCONFIG_ALLCONFIG trick.
See README for usage.

	Sam
