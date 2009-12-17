Return-Path: <linux-kernel-owner+w=401wt.eu-S1752576AbZLREPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbZLREPS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 23:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbZLREPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 23:15:16 -0500
Received: from smtp-out5.blueyonder.co.uk ([195.188.213.8]:58516 "EHLO
	smtp-out5.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901AbZLREPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 23:15:15 -0500
X-Greylist: delayed 21506 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Dec 2009 23:15:15 EST
Message-ID: <4B2AADCD.4080802@blueyonder.co.uk>
Date: Thu, 17 Dec 2009 22:16:45 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0 ThunderBrowse/3.2.6.8
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [GIT PULL] omap build fixes
References: <20091216223520.GV4575@atomide.com> <4B2A1635.1080505@blueyonder.co.uk> <20091217172600.GY4575@atomide.com>
In-Reply-To: <20091217172600.GY4575@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/12/09 17:26, Tony Lindgren wrote:
> * Sid Boyce <sboyce@blueyonder.co.uk> [091217 03:29]:
> 
> <snip>
>  
>> uImage built, so EHCI build problem definitely fixed, just one error
>> I've previously encountered when building modules.
>> slipstream:/home/lancelot/ftp/dec09/OMAP/omap-fixes-for-linus # ARCH=arm
>> make -j 4 CROSS_COMPILE=/opt/arm-2009q3/bin/arm-none-eabi- modules
>> scripts/kconfig/conf -s arch/arm/Kconfig
>>   CHK     include/linux/version.h
>>   SYMLINK include/asm -> include/asm-arm
>> make[1]: `include/asm-arm/mach-types.h' is up to date.
>>   CHK     include/linux/utsrelease.h
>>   CALL    scripts/checksyscalls.sh
>> <stdin>:1523: warning: #warning syscall recvmmsg not implemented
>>   Building modules, stage 2.
>>   MODPOST 99 modules
>> ERROR: "omap_ctrl_writel" [sound/soc/omap/snd-soc-omap-mcbsp.ko] undefined!
>> ERROR: "omap_ctrl_readl" [sound/soc/omap/snd-soc-omap-mcbsp.ko] undefined!
>> make[1]: *** [__modpost] Error 1
>> make: *** [modules] Error 2
> 
> Hmm. I'm not seeing this in any of the defconfigs, so I guess this
> happens with ASoC complied as a module.
> 
> But instead of exporting omap_ctrl_read/write, we need to get rid of 
> omap_ctrl_read/write stuff in the drivers.
> 
> It seems that omap_mcbsp_dai_set_clks_src() should be implemented in
> the clock framework instead.
> 
> Regards,
> 
> Tony
> 
> 

Confirmed it works when compiled in.
Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

