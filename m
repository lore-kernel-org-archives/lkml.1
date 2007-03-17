Return-Path: <linux-kernel-owner+w=401wt.eu-S1751915AbXCQXdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbXCQXdz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 19:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbXCQXdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 19:33:54 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33838 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751696AbXCQXdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 19:33:54 -0400
Date: Sun, 18 Mar 2007 00:33:56 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: fake config option w/kbuild?
Message-ID: <20070317233356.GL752@stusta.de>
References: <C6F49569-655E-4B17-B9DA-9644C8B3668D@kernel.crashing.org> <20070315191258.GA752@stusta.de> <88F9283D-B8FD-46F9-8A94-CB824630C232@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <88F9283D-B8FD-46F9-8A94-CB824630C232@kernel.crashing.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 03:08:47PM -0500, Kumar Gala wrote:
> 
> On Mar 15, 2007, at 2:12 PM, Adrian Bunk wrote:
> 
> >On Thu, Mar 15, 2007 at 10:19:03AM -0500, Kumar Gala wrote:
> >>...
> >>My initial question is that I don't want anyone using CONFIG_QE_83xx
> >>or CONFIG_QE_85xx in code, the second part is if there is a way to
> >>remove duplicating the QE_83xx/QE_85xx options down in platform/8 
> >>{3,5}
> >>xx/Kconfig.
> >
> >
> >What about the following solution:
> >
> >
> >arch/powerpc/Kconfig.qe:
> >
> ><--  snip  -->
> >
> >config MACH_SUPPORTS_QE
> >	bool
> >
> >config QE
> >	bool "QUICC Engine Support"
> >	depends on MACH_SUPPORTS_QE
> >	help
> >	  ...
> >
> ><--  snip  -->
> >
> >
> >arch/powerpc/platforms/83xx/Kconfig:
> >
> ><--  snip  -->
> >
> >...
> >source arch/powerpc/Kconfig.qe
> >
> >config PPC_MPC836x
> >        bool
> >	select MACH_SUPPORTS_QE
> >	...
> >....
> >
> ><--  snip  -->
> 
> Not sure this helps since I end up having to source arch/powerpc/ 
> Kconfig.qe from both arch/powerpc/platforms/83xx/Kconfig & arch/ 
> powerpc/platforms/85xx/Kconfig and then mconf grips about having  
> already scanned Kconfig.qe.


Sorry, my fault that I didn't test it myself before suggesting it.

It seems there is no solution for both not duplicating the options and 
getting them in the desired menu.


> - k

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

