Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153Ab0AFTen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab0AFTen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 14:34:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755960Ab0AFTel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 14:34:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40203 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755516Ab0AFTel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 14:34:41 -0500
Message-ID: <4B44E5C8.2050006@suse.cz>
Date: Wed, 06 Jan 2010 20:34:32 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Don't mkdir -p include/config in the sourcetree when
 using O=outputdir option
References: <alpine.LFD.2.00.1001061705140.3744@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1001061705140.3744@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Kacur napsal(a):
> The following is an example of how the Makefile currently can fail.
> [jkacur@tycho rt.linux.git]$ make mrproper
> [jkacur@tycho rt.linux.git]$ mkdir /bld/2.6.33-rc3
> [jkacur@tycho rt.linux.git]$ cp /bld/config /bld/2.6.33-rc3/.config
> [jkacur@tycho rt.linux.git]$ make O=/bld/2.6.33-rc3/ oldconfig
>   HOSTCC  scripts/basic/fixdep
>   HOSTCC  scripts/basic/docproc
>   HOSTCC  scripts/basic/hash
>   GEN     /bld/2.6.33-rc3/Makefile
>   HOSTCC  scripts/kconfig/conf.o
>   HOSTCC  scripts/kconfig/kxgettext.o
>   HOSTCC  scripts/kconfig/zconf.tab.o
>   HOSTLD  scripts/kconfig/conf
> scripts/kconfig/conf -o arch/x86/Kconfig
> [jkacur@tycho rt.linux.git]$ make O=/bld/2.6.33-rc3/
>   GEN     /bld/2.6.33-rc3/Makefile
> scripts/kconfig/conf -s arch/x86/Kconfig
>   Using /home/jkacur/rt.linux.git as source for kernel
>   /home/jkacur/rt.linux.git is not clean, please run 'make mrproper'
>   in the '/home/jkacur/rt.linux.git' directory.
> make[1]: *** [prepare3] Error 1
> make: *** [sub-make] Error 2
> [jkacur@tycho rt.linux.git]$ ls -ld include/config/
> drwxrwxr-x 2 jkacur jkacur 6 2010-01-06 15:58 include/config/
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---
>  Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 1231094..7d8d722 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -458,7 +458,7 @@ config: scripts_basic outputmakefile FORCE
>  	$(Q)$(MAKE) $(build)=scripts/kconfig $@
>  
>  %config: scripts_basic outputmakefile FORCE
> -	$(Q)mkdir -p include/linux include/config
> +	$(Q)mkdir -p $(objtree)/include/linux include/config
>  	$(Q)$(MAKE) $(build)=scripts/kconfig $@

Can you double-check that this patch really fixes your issue and that
without this patch it fails again? Because 1) I can't reproduce this
behaviour and I also don't see how it could f, 2) your problem is a
include/config file somehow created in the source tree, but you patch
the creation of include/linux. And if there really needs to be a fix,
the same should be applied to the identical block above.

thanks,
Michal
