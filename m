Return-Path: <linux-kernel-owner+w=401wt.eu-S1761631AbYEXUIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761631AbYEXUIK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 16:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbYEXUH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 16:07:57 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:40050 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146AbYEXUH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 16:07:56 -0400
Date: Sat, 24 May 2008 23:05:24 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [RFC PATCH] kconfig: introduce KCONFIG_* symbols for .c files
Message-ID: <20080524200523.GB2308@cs181133002.pp.htv.fi>
References: <20080524192540.GA28067@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080524192540.GA28067@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 09:25:40PM +0200, Sam Ravnborg wrote:
> We have many places in the kernel that looks like
> the following:
> 
> #ifdef CONFIG_FOO
> 	...
> #endif
> 
> Which has the disadvantage that the code denoted '...'
> are not even built if CONFIG_FOO is not selected in
> the current configuration.
> 
> We know that gcc do simple code-elimination for
> conditionals which is always true/false and
> thus the above code could be turned into:
> 
> 	if (CONFIG_FOO)
> 		...
> 
> One line smaller and we follow the normal flow in the program.
> The code is always build but we do not waste space as gcc will
> do proper code-elimination for us.
> 
> Today this is not possible because kconfig will only
> define CONFIG_FOO if selected and FOO is not a module.
> 
> The following patch implement a new set of defines in
> the KCONFIG_* namespace.
> 
> For a tristate symbol the following are defined:
> 
> FOO not selected: 
> #define KCONFIG_FOO        0
> #define KCONFIG_FOO_MODULE 0
> 
> FOO is built-in ('y')
> #define KCONFIG_FOO        1
> #define KCONFIG_FOO_MODULE 0
> 
> FOO is a module ('m'):
> #define KCONFIG_FOO        1
> #define KCONFIG_FOO_MODULE 1
> 
> In other words KCONFIG_FOO will say if the
> symbol is selected and KCONFIG_FOO_MODULE
> will say if it is a module.

If you really want to be able to transform all #if's in .c files to 
if()'s you also have to offer a variant of our MODULE #define.

> With the above included we can now do:
> 
> 	if (KCONFIG_FOO)
> 		...
> 
> This is not a replacement for the CONFIG_*
> defines but a pleasant supplement.
> Using KCONFIG_FOO will also give us a nice
> error message the day that FOO is no longer part
> of the configuration.
>...

Also an error message if if the varible is not currently available on 
this architecture (e.g. KCONFIG_ISA on ia64).

Not an unsolvable problem, but something that has to be taken care of.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

