Return-Path: <linux-kernel-owner+w=401wt.eu-S932801AbXCOTM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801AbXCOTM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933439AbXCOTM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:12:58 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60494 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932806AbXCOTM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:12:57 -0400
Date: Thu, 15 Mar 2007 20:12:59 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: fake config option w/kbuild?
Message-ID: <20070315191258.GA752@stusta.de>
References: <C6F49569-655E-4B17-B9DA-9644C8B3668D@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <C6F49569-655E-4B17-B9DA-9644C8B3668D@kernel.crashing.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 10:19:03AM -0500, Kumar Gala wrote:
>...
> My initial question is that I don't want anyone using CONFIG_QE_83xx  
> or CONFIG_QE_85xx in code, the second part is if there is a way to  
> remove duplicating the QE_83xx/QE_85xx options down in platform/8{3,5} 
> xx/Kconfig.


What about the following solution:


arch/powerpc/Kconfig.qe:

<--  snip  -->

config MACH_SUPPORTS_QE
	bool

config QE
	bool "QUICC Engine Support"
	depends on MACH_SUPPORTS_QE
	help
	  ...

<--  snip  -->


arch/powerpc/platforms/83xx/Kconfig:

<--  snip  -->

...
source arch/powerpc/Kconfig.qe

config PPC_MPC836x
        bool
	select MACH_SUPPORTS_QE
	...
....

<--  snip  -->


> thanks
> 
> - kumar

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

