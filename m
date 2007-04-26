Return-Path: <linux-kernel-owner+w=401wt.eu-S1754915AbXDZRn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbXDZRn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754923AbXDZRn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:43:59 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754915AbXDZRn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:43:58 -0400
Date: Thu, 26 Apr 2007 10:42:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Josh Triplett <josh@kernel.org>
cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
In-Reply-To: <4630DF19.3060805@kernel.org>
Message-ID: <alpine.LFD.0.98.0704261036120.9964@woody.linux-foundation.org>
References: 20070425232806.GL17387@elf.ucw.cz <4630DF19.3060805@kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Apr 2007, Josh Triplett wrote:
> 
> http://www.gettysfamily.org/wordpress/?p=32
> http://www.gettysfamily.org/wordpress/?p=33
> 
> You cannot resume "too fast"; suspend to RAM should become so fast that you
> use it without even thinking about it.

Yes. I think the OLPC is a prime example of why suspend-to-ram should 
basically try to not do any setup at all: leave all the DMA command 
structures etc in memory, leave even things like USB URB's pending, just 
"stop the actual controllers and suspend it".

If you want to just save power by shutting down the CPU, it's a great idea 
to leave the NIC powered up etc, so that you don't have to renegotiate the 
link speed etc, and that you can go into s2ram and come back in less than 
a second. 

Then, if you really want to *sleep*, you can have a s2ram script that 
actually turns off devices for real and requires more tear-down and setup, 
but having something that tries to get in and out of the processor sleep 
modes as fast as possible is definitely interesting.

Obviously, it's *more* interesting on the OLPC than on many other machines 
(since that one can keep its display refreshed while it's sleeping), so it 
may well be that the OLPC is one extreme example that isn't very realistic 
for some other uses, but I think it's one of the things we want to 
support.

(And for me personally, I'd love to have all my machines "sleep" by 
default, but wake up by eithernet and keyboard - I'd love for my screen 
saver to literally put the machine to sleep, but not have to worry about 
touching a keyboard - just ssh'ing into them should still wake up. It's 
*technically* doable, but it's just a pain to do right now)

		Linus
