Return-Path: <linux-kernel-owner+w=401wt.eu-S1758052AbYDTQDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbYDTQDs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 12:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754638AbYDTQDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 12:03:40 -0400
Received: from smtp.enter.net ([216.193.128.24]:3303 "EHLO smtp.enter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754618AbYDTQDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 12:03:39 -0400
X-Greylist: delayed 1143 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Apr 2008 12:03:38 EDT
From: Daniel Hazelton <dhazelton@enter.net>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: x86: 4kstacks default
Date: Sun, 20 Apr 2008 11:44:32 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200804181737.m3IHbabI010051@hera.kernel.org> <20080420104444.GI1595@cs181133002.pp.htv.fi> <87y778aezh.fsf@basil.nowhere.org>
In-Reply-To: <87y778aezh.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804201144.33308.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 April 2008 08:27:14 Andi Kleen wrote:
> Adrian Bunk <bunk@kernel.org> writes:
> > 6k is known to work, and there aren't many problems known with 4k.
> >
> > And from a QA point of view the only way of getting 4k thoroughly tested
>
> But you have to first ask why do you want 4k tested? Does it serve
> any useful purpose in itself? I don't think so. Or you're saying
> it's important to support 50k kernel threads on 32bit kernels?
>
> -Andi

Andi, you're the only one I've seen seriously pounding the "50k threads" 
thing - I don't think anyone is really fooled by the straw-man, so I'd 
suggest you drop it.

The real issue is that you think (and are correct in thinking) that people are 
idiots. Yes, there will be breakages if the default is changed to 4k stacks - 
but if people are running new kernels on boxes that'll hit stack use problems 
(that *AREN'T* related to ndiswrapper) and haven't made sure that they've 
configured the kernel properly, then they deserve the outcome. It isn't the 
job of the Linux Kernel to protect the incompetent - nor is it the job of 
linux kernel developers to do such.

If people are doing a "zcat /proc/kconfig.gz > .config && make oldconfig" (or 
similar) the problem shouldn't even appear, really. They'll get whatever 
setting was in their old config for the stack size. And until the problems 
with deep-stack setups - like nfs+xfs+raid - get resolved I'd think that the 
option to configure the stack size would remain.

Since the second-most-common reason for stack overages is ndiswrapper... Well, 
with there being so much more hardware now supported directly by the linux 
kernel... I'm stunned every time someone tells me "I can't run Linux on my 
laptop, there is hardware that isn't supported without me having to get 
ndiswrapper". The last time someone said that to me I pointed to the fact 
that their hardware is supported by the latest kernel and even offered to 
build&install it for them.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
