Return-Path: <linux-kernel-owner+w=401wt.eu-S1761796AbYBRWW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761796AbYBRWW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 17:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbYBRWWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 17:22:19 -0500
Received: from an-out-0708.google.com ([209.85.132.245]:47616 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbYBRWWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 17:22:18 -0500
Message-ID: <47BA0486.7000508@larces.uece.br>
Date: Mon, 18 Feb 2008 19:19:50 -0300
From: Sergio Luis <sergio@larces.uece.br>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Christian Kujau <lists@nerdbynature.de>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [build bug] lguest build failure: drivers/lguest/x86/switcher_32.S:(.text+0x3815f8):
 undefined reference to `LGUEST_PAGES_regs_trapnum'
References: <20080201124520.GA29900@elte.hu> <20080201170551.GA3825@elte.hu> <200802040711.11280.rusty@rustcorp.com.au> <alpine.LFD.1.00.0802171451060.7583@apollo.tec.linutronix.de> <47B83F90.7000203@larces.uece.br> <alpine.DEB.1.00.0802172109590.6469@sheep.housecafe.de> <47B8D99A.3020202@larces.uece.br> <47B8DFD8.6040602@larces.uece.br> <alpine.DEB.1.00.0802182305590.6469@sheep.housecafe.de>
In-Reply-To: <alpine.DEB.1.00.0802182305590.6469@sheep.housecafe.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Kujau wrote:
> On Sun, 17 Feb 2008, Sergio Luis wrote:
>> oops. sorry, I just realized I missed the makefile part. I changed
>> the config symbol to CONFIG_LGUEST_HYPERVISOR so I should change it on
>> the makefile as well. reposting an updated patch for testing:
> 
> Hm, now I cannot select LGUEST as a module any more:
> 
> $ make clean && time make
>   [...]
>   HOSTCC  scripts/kconfig/zconf.tab.o
>   HOSTLD  scripts/kconfig/conf
> scripts/kconfig/conf -s arch/x86/Kconfig
> .config:1793:warning: symbol value 'm' invalid for LGUEST
>   [...]
>   Linux hypervisor (LGUEST) [Y/n/?] (NEW)

if you select Y here it will prompt you about the lguest hypervisor, the code in question, the one you want to build, and you will then be able to select it as a module, if you want, or built-in into the kernel. 
I dont like this approach myself, but it does fix the problem. I was hoping people would come up with better ideas on how to properly fix it.
-sergio

> 
> Is this intentional? I've tried your patch with or without Rusty's
> patch, both gave me the same results. My .config:
> http://nerdbynature.de/bits/2.6.25-rc2/lguest/
> 
> Thanks,
> Christian.

