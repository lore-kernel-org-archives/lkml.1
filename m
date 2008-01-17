Return-Path: <linux-kernel-owner+w=401wt.eu-S1752902AbYAQRO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbYAQRO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 12:14:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbYAQROW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 12:14:22 -0500
Received: from waste.org ([66.93.16.53]:34788 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbYAQROV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 12:14:21 -0500
Subject: Re: [PATCH] x86: fix unconditional
	arch/x86/kernel/pcspeaker.c	compiling
From: Matt Mackall <mpm@selenic.com>
To: Michael Opdenacker <michael-lists@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, Linux-tiny@selenic.com,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <478F8AEC.1080209@free-electrons.com>
References: <200801171643.49301.michael-lists@free-electrons.com>
	 <1200587774.5332.11.camel@cinder.waste.org>
	 <478F8AEC.1080209@free-electrons.com>
Content-Type: text/plain
Date: Thu, 17 Jan 2008 11:13:51 -0600
Message-Id: <1200590031.5332.19.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-17 at 18:05 +0100, Michael Opdenacker wrote:
> Hi Matt,
> 
> Thanks for your feedback!
> 
> On 01/17/2008 05:36 PM, Matt Mackall wrote:
> > On Thu, 2008-01-17 at 16:43 +0100, Michael Opdenacker wrote:
> >   
> >> diff -Naur linux-2.6.24-rc8-git1/arch/x86/kernel/Makefile_32 linux-2.6.24-rc8-git1-nopcspeaker/arch/x86/kernel/Makefile_32
> >> --- linux-2.6.24-rc8-git1/arch/x86/kernel/Makefile_32	2008-01-17 09:48:58.000000000 +0100
> >> +++ linux-2.6.24-rc8-git1-nopcspeaker/arch/x86/kernel/Makefile_32	2008-01-17 10:06:56.000000000 +0100
> >> @@ -45,10 +45,13 @@
> >>  
> >>  obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
> >>  obj-$(CONFIG_PARAVIRT)		+= paravirt_32.o
> >> -obj-y				+= pcspeaker.o
> >> -
> >>  obj-$(CONFIG_SCx200)		+= scx200_32.o
> >>  
> >> +ifeq ($(CONFIG_INPUT_PCSPKR),y)
> >> +	obj-y			+= pcspeaker.o
> >> +endif
> >>     
> >
> > I'm not sure this does what you want. What if CONFIG_INPUT_PCSPKR = m?
> >   
> Does it make sense to compile arch/x86/kernel/pcspeaker.c as a module?
> It defines no init and exit functions, and it defines an initcall, which
> only makes sense at boot time.

Probably not. However, the above code won't build pcspeaker.o if
CONFIG_INPUT_PCSPKR = m. In other words, it'll break.

-- 
Mathematics is the supreme nostalgia of our time.

