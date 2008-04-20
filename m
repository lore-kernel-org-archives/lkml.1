Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861AbYDTVAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbYDTVAA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 17:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYDTU74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 16:59:56 -0400
Received: from smtp.enter.net ([216.193.128.24]:4776 "EHLO smtp.enter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbYDTU74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 16:59:56 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: 7eggert@gmx.de
Subject: Re: x86: 4kstacks default
Date: Sun, 20 Apr 2008 16:59:51 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>
References: <ak6tq-32p-7@gated-at.bofh.it> <akKhi-91-37@gated-at.bofh.it> <E1Jng4g-0003WM-Bu@be1.7eggert.dyndns.org>
In-Reply-To: <E1Jng4g-0003WM-Bu@be1.7eggert.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804201659.52902.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 April 2008 16:23:45 Bodo Eggert wrote:
> Daniel Hazelton <dhazelton@enter.net> wrote:
> > On Sunday 20 April 2008 08:27:14 Andi Kleen wrote:
> >> Adrian Bunk <bunk@kernel.org> writes:
> >> > 6k is known to work, and there aren't many problems known with 4k.
> >> >
> >> > And from a QA point of view the only way of getting 4k thoroughly
> >> > tested
> >>
> >> But you have to first ask why do you want 4k tested? Does it serve
> >> any useful purpose in itself? I don't think so. Or you're saying
> >> it's important to support 50k kernel threads on 32bit kernels?
> >
> > Andi, you're the only one I've seen seriously pounding the "50k threads"
> > thing - I don't think anyone is really fooled by the straw-man, so I'd
> > suggest you drop it.
> >
> > The real issue is that you think (and are correct in thinking) that
> > people are idiots. Yes, there will be breakages if the default is changed
> > to 4k stacks - but if people are running new kernels on boxes that'll hit
> > stack use problems (that *AREN'T* related to ndiswrapper) and haven't
> > made sure that they've configured the kernel properly, then they deserve
> > the outcome. It isn't the job of the Linux Kernel to protect the
> > incompetent - nor is it the job of linux kernel developers to do such.
>
> It's the job of the kernel developers to mark experimental and broken
> options, and to put a warning:
>
> "This will break stacking of drivers, especially if disk manager, xfs, RAID
> and nfs are used. Yes, linux is broken by default, but only if you intend
> to set up a reliable system, so this will be OK!"
>
> into the help text, instead of expecting each admin to read lkml.

Note that I've yet to meet a competent admin that creates brand new 
configurations each time they build a new kernel for a machine. Usually they 
have a "default configuration" for each machine that gets updated each time a 
new kernel is built. Usually they don't change working options. And since 
changing things to 4K stacks default would cause a new option - the "8K 
stacks" option to show up in a "make oldconfig" run - the admin would see it 
and, hopefully, check the help text and see that it his system, with a deeply 
stacked driver system (nfs+xfs+raid, for example) and set the 8K stacks 
option to "Y".

As I said, it isn't the job of the kernel or kernel developers to protect the 
incompetent (or the lazy).

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
