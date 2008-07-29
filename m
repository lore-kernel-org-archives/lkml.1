Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbYG2D0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbYG2D0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 23:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbYG2D0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 23:26:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752297AbYG2D0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 23:26:21 -0400
Date: Mon, 28 Jul 2008 20:23:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux v2.6.27-rc1
Message-ID: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's two weeks (and one day), and the merge window is over.

Finally. I don't know why, but this one really did feel pretty dang busy. 
And the size of the -rc1 patch bears that out - at 12MB, it's about 50% 
bigger than 26-rc1 (but not that much bigger than 24/25-rc1, so it's not 
like it's anything unheard of).

The pure size of the -rc's _is_ making me a bit nervous, though. Sure, it 
means that we are good at merging it all, but I have to say that I 
sometimes wonder if we don't merge too much in one go, and even our 
current (fairly short) release cycle is actually too big.

Anyway, that's a discussion for some other event.

Much of -rc1 was in linux-next, but certainly not everything. We'll see 
how that whole thing ends up evolving - it certainly didn't solve all 
problems, and there was some bickering about things that weren't there 
(and some things that mostly were ;), but maybe it helped.

There's a ton of new stuff in there, but at least personally the 
interesting things are the BKL pushdown and perhaps the introduction of 
the lockless get_user_pages_fast(). The build system also got updated to 
allow moving the architecture include files ("include/asm-xyz") into the 
architecture subdirectories ("arch/xyz/include/asm"), and sparc seems to 
have taken advantage of that already.

But those changes are just small details in the end. As usual, the bulk of 
changes are all to device drivers (roughly half, as usual), with the arch 
directory amounting to about half of the remainder. Dirstat:

   3.2% arch/arm/
   9.2% arch/ppc/
  24.6% arch/
   5.2% drivers/char/drm/
   6.3% drivers/char/
   4.5% drivers/gpu/drm/
   4.5% drivers/gpu/
   4.6% drivers/media/video/
   5.5% drivers/media/
   3.0% drivers/net/wireless/
  10.7% drivers/net/
   6.4% drivers/usb/misc/
   4.7% drivers/usb/serial/
  12.9% drivers/usb/
  51.2% drivers/
   4.4% firmware/
   3.7% fs/
   9.2% include/

where the bulk of that fs/ update is the merge of the UBI filesystem, to 
pick one fairly sizeable chunk outside of arch or drivers (there's omfs 
too, but that's tiny in comparison).

Other stuff? tracing. firmware loading. continued x86 arch merging. And 
moving more code to generic support (unified generic IPI handling, 
coherent dma memory allocation, show_mem etc). bootmem rewrites. Some 
support for further scalability (ie 4k cpu cores).

But mostly lots and lots of driver and arch updates.

Go to kernelnewbies or lwn for more reporting, I'm going to sleep for 
twenty-four hours now ;)

			Linus
