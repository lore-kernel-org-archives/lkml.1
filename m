Return-Path: <linux-kernel-owner+w=401wt.eu-S1752576AbZGLT77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbZGLT77 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 15:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbZGLT7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 15:59:50 -0400
Received: from mail.gmx.net ([213.165.64.20]:37053 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751968AbZGLT7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 15:59:49 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1++S2RZblq+lzHK5lkGTWAJXELQm508dW2DzAJeR/
	uzk6whJJ/uCb+A
Date: Sun, 12 Jul 2009 21:59:47 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-mm@kvack.org,
       kernel@avr32linux.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG 2.6.30] Bad page map in process
In-Reply-To: <20090712095731.3090ef56@siona>
Message-ID: <Pine.LNX.4.64.0907122151010.13280@axis700.grange>
References: <Pine.LNX.4.64.0907081250110.15633@axis700.grange>
 <Pine.LNX.4.64.0907101900570.27223@sister.anvils> <20090712095731.3090ef56@siona>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Jul 2009, Haavard Skinnemoen wrote:

> On Fri, 10 Jul 2009 19:34:06 +0100 (BST)
> Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
> 
> > I've not looked up avr32 pte layout, is 13f26ed4 good or bad?
> > I hope avr32 people can tell more about the likely cause.
> 
> It looks OK for a user mapping, assuming you have at least 64MB of
> SDRAM (the SDRAM starts at 0x10000000) -- all the normal userspace flags
> are set and all the kernel-only flags are unset. It's marked as
> executable, so it could be that the segfault was caused by the CPU
> executing the wrong code.
> 
> The virtual address 0x4377f876 is a bit higher than what you normally
> see on avr32 systems, but there's not necessarily anything wrong with
> it -- userspace goes up to 0x80000000.
> 
> Btw, is preempt enabled when you see this?

No, preempt was off.

I can give a couple more details to the problem:

1. it might well be hardware-related.

2. the specific BUG that I posted originally wasn't very interesting, 
because it wasn't the first one. Having read a few posts I wasn't quite 
sure how really severe this BUG was, i.e., whether or not it requiret a 
reboot. There used to be a message like "reboot is required" around this 
sort of exceptions, but then it has been removed, so, I thought, it wasn't 
required any more. But the fact is, that once one such BUG has occurred, 
new ones will come from various applications and eventually the system 
will become unusable.

3. What makes it a kind of hard to believe that it's a hardware problem, 
is that up to now we have only been able to produce the _first_ such 
segfault and BUG with just one specific user-space application. In 
principle the application doesn't do anything critical. It just uses Qt ta 
draw on the framebuffer. And we have been able to reproduce the problem by 
running just a truncated version of the app - just the Qt and local class 
initialisation. Running such an application repeatedly eventually produces 
a segfault, and at some point also the "bad page map" BUG.

We're currently trying to investigate and fix the hardware, will post our 
results.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
