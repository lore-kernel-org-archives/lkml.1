Return-Path: <linux-kernel-owner+w=401wt.eu-S1765048AbZLQR0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765048AbZLQR0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 12:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765042AbZLQR0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 12:26:11 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:55935 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765038AbZLQR0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 12:26:08 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+pxng68ubTLbCg4ZhiJHys
Date: Thu, 17 Dec 2009 09:26:01 -0800
From: Tony Lindgren <tony@atomide.com>
To: Sid Boyce <sboyce@blueyonder.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [GIT PULL] omap build fixes
Message-ID: <20091217172600.GY4575@atomide.com>
References: <20091216223520.GV4575@atomide.com>
 <4B2A1635.1080505@blueyonder.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2A1635.1080505@blueyonder.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sid Boyce <sboyce@blueyonder.co.uk> [091217 03:29]:

<snip>
 
> uImage built, so EHCI build problem definitely fixed, just one error
> I've previously encountered when building modules.
> slipstream:/home/lancelot/ftp/dec09/OMAP/omap-fixes-for-linus # ARCH=arm
> make -j 4 CROSS_COMPILE=/opt/arm-2009q3/bin/arm-none-eabi- modules
> scripts/kconfig/conf -s arch/arm/Kconfig
>   CHK     include/linux/version.h
>   SYMLINK include/asm -> include/asm-arm
> make[1]: `include/asm-arm/mach-types.h' is up to date.
>   CHK     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
> <stdin>:1523: warning: #warning syscall recvmmsg not implemented
>   Building modules, stage 2.
>   MODPOST 99 modules
> ERROR: "omap_ctrl_writel" [sound/soc/omap/snd-soc-omap-mcbsp.ko] undefined!
> ERROR: "omap_ctrl_readl" [sound/soc/omap/snd-soc-omap-mcbsp.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2

Hmm. I'm not seeing this in any of the defconfigs, so I guess this
happens with ASoC complied as a module.

But instead of exporting omap_ctrl_read/write, we need to get rid of 
omap_ctrl_read/write stuff in the drivers.

It seems that omap_mcbsp_dai_set_clks_src() should be implemented in
the clock framework instead.

Regards,

Tony
