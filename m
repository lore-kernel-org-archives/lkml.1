Return-Path: <linux-kernel-owner+w=401wt.eu-S1761617AbYARNDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761617AbYARNDr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 08:03:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760825AbYARNDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 08:03:17 -0500
Received: from free-electrons.com ([88.191.23.47]:41978 "EHLO
	sd-2511.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760751AbYARNDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 08:03:16 -0500
Message-ID: <4790A385.800@free-electrons.com>
Date: Fri, 18 Jan 2008 14:03:01 +0100
From: Michael Opdenacker <michael-lists@free-electrons.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       Linux-tiny@selenic.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: fix unconditional	arch/x86/kernel/pcspeaker.c?compiling
References: <200801171643.49301.michael-lists@free-electrons.com> <478F8AEC.1080209@free-electrons.com> <1200590031.5332.19.camel@cinder.waste.org> <200801172315.29976.michael-lists@free-electrons.com> <20080118110252.GA17397@elte.hu> <47909821.1090907@free-electrons.com> <20080118122540.GH11044@elte.hu> <20080118122926.GA15216@elte.hu>
In-Reply-To: <20080118122926.GA15216@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2008 01:29 PM, Ingo Molnar wrote:
>> perhaps the right solution would be to only build it in if 
>> CONFIG_PCSPEAKER is "y" or "m". I.e. your original patch?
>>     
>
> i've added your patch to x86.git - see below.
>   
Many thanks Ingo!
> Index: linux-x86.q/arch/x86/kernel/Makefile
> ===================================================================
> --- linux-x86.q.orig/arch/x86/kernel/Makefile
> +++ linux-x86.q/arch/x86/kernel/Makefile
> @@ -68,7 +68,10 @@ obj-$(CONFIG_MGEODE_LX)		+= geode_32.o m
>  
>  obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
>  obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o
> +
> +ifdef CONFIG_INPUT_PCSPKR
>  obj-y				+= pcspeaker.o
> +endif
>  
>  obj-$(CONFIG_SCx200)		+= scx200_32.o
>   
However, wouldn't the Makefile look nicer if we introduced a
CONFIG_PCSPEAKER setting as in the mips platform? We would just have:

obj-$(CONFIG_PCSPEAKER)		+= pcspeaker.o


I can propose a corresponding patch, and I'd suggest to make
CONFIG_PCSPEAKER depend on CONFIG_EMBEDDED.

Thanks again!

:-)

Michael.

-- 
Michael Opdenacker, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)

