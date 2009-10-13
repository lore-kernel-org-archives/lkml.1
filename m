Return-Path: <linux-kernel-owner+w=401wt.eu-S933834AbZJMPGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933834AbZJMPGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757788AbZJMPGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:06:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752734AbZJMPGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:06:07 -0400
Date: Tue, 13 Oct 2009 08:05:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Boyan <btanastasov@yahoo.co.uk>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_L=2E_W=2E_Meunier?= 
	<fredlwm@gmail.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>, Nix <nix@esperi.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Fulghum <paulkf@microgate.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
In-Reply-To: <4AD437F9.9020708@yahoo.co.uk>
Message-ID: <alpine.LFD.2.01.0910130745550.3438@localhost.localdomain>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <L6tb-VyKHZK.A.PaB.Ozl0KB@chimera> <C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com> <87ljjgfcbu.fsf@spindle.srvr.nix> <alpine.LFD.2.01.0910121703390.3438@localhost.localdomain> <alpine.LFD.2.01.0910122004200.3438@localhost.localdomain>
 <4AD3F769.5080405@gmail.com> <alpine.LNX.2.01.0910130405200.9297@dyndns.pervalidus.net> <4AD437F9.9020708@yahoo.co.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Oct 2009, Boyan wrote:
> 
> I've just tested it on top of 2.6.31.3 and it doesn't work. As I've
> mentioned in previous email - I usually trigger the problem easily
> watching pictures with gthumb - this is combination of cpu intensive
> operations and keyboard usage and if it doesn't work it takes me no more
> than a minute to trigger the problem.

The whole "CPU intensive" thing makes me wonder..

Do you have 'CONFIG_PREEMPT' enabled? Normally, "CPU intensive" does not 
at all increase the likelihood of any kernel races, but with kernel 
preemption we may well hit some preemption point and switch away, and make 
some race window much bigger.

So if you do have CONFIG_PREEMPT on, try to turn it off and see if it 
makes the problem go away. Also, are people seeing this always running SMP 
kernels, or are there UP kernels out there too (on UP _without_ preemption 
it is almost impossible to hit 99% of all race conditions, so if anybody 
is running an UP kernel with no preemption, then I'd be very surprised if 
it is a kernel issue).

But I also still wonder if it might be user-space races, and just the 
timing differences in the kernel. I don't know the input layer in X well 
enough, I'm wondering if things like composition engine/window manager 
could screw up here. Is there some pattern to the X versions (and/or 
window managers and composition engines)?

			Linus
