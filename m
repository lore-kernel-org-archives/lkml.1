Return-Path: <linux-kernel-owner+w=401wt.eu-S932320AbYECSPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320AbYECSPb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 14:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766014AbYECSPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 14:15:07 -0400
Received: from mail.gmx.net ([213.165.64.20]:54714 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760855AbYECSPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 14:15:06 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19gxixHp+VggglfhMZRHwWLEPe8r0Ev5fp+flSpNn
	HBOM5wPDDiCQQH
Date: Sat, 3 May 2008 20:15:20 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [patch] video: build fix for drivers/media/video/mt9v022.c
In-Reply-To: <20080503175807.GC5292@elte.hu>
Message-ID: <Pine.LNX.4.64.0805032004130.5182@axis700.grange>
References: <20080503163058.GA15272@elte.hu> <Pine.LNX.4.64.0805031853180.5182@axis700.grange>
 <20080503175807.GC5292@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 May 2008, Ingo Molnar wrote:

> * Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> 
> > > with this config:
> > > 
> > >    http://redhat.com/~mingo/misc/config-Sat_May__3_16_08_39_CEST_2008.bad
> > > 
> > > the bug was that the driver uses GPIO functionality but only 
> > > includes the GPIO interface definitions for the 
> > > CONFIG_MT9M001_PCA9536_SWITCH case, which was not set in this 
> > > config.
> > 
> > Ok, once again a good catch and a wrong fix, sorry :-) The bug is that 
> > not CONFIG_MT9M001_PCA9536_SWITCH but CONFIG_MT9V022_PCA9536_SWITCH 
> > shall be checked for, of course. Copy-paste:-( I'll prepare a correct 
> > patch and submit it. As for the "cleanup" side - don't know. Would it 
> > be better to unconditionally include it? It won't hurt of course, 
> > looks better, but is unneeded when the GPIO is not used. And, although 
> > grep reports most drivers including asm/gpio.h, including linux/gpio.h 
> > seems indeed better.
> 
> No. If you look at the core kernel you wont see it sprinkled with things 
> like:
> 
>  #ifdef CONFIG_LOCKDEP
>  #include <linux/lockdep.h>
>  #endif
> 
> why? Because we have put all such things into the include file 
> themselves and do not want to sprinkle .c files with ugly #ifdefs. This 
> is a basic cleanliness issue.

Ok, right, sorry, the patch was indeed correct, just the reason for the 
compilation breakage was not quite what you suggested. So, I'll apply your 
putch, but please fix mt9m001.c in the same patch too - it also includes 
gpio.h conditionally. Although, it does test the correct macro.

Actually, this CONFIG option might disappear completely in the future, if 
we decide to switch to a module parameter instead. So that one kernel can 
be used on systems with and without the GPIO.

Thanks
Guennadi
---
Guennadi Liakhovetski
