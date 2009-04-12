Return-Path: <linux-kernel-owner+w=401wt.eu-S1754404AbZDLPHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbZDLPHb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 11:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbZDLPHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 11:07:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35911 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752830AbZDLPHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 11:07:20 -0400
Date: Sun, 12 Apr 2009 07:59:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Avi Kivity <avi@redhat.com>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
       rjw@sisk.pl, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/setup] x86, setup: "glove box" BIOS calls --
 infrastructure
In-Reply-To: <49E17A6E.5000104@zytor.com>
Message-ID: <alpine.LFD.2.00.0904120754240.4583@localhost.localdomain>
References: <49DE7F79.4030106@zytor.com> <tip-7a734e7dd93b9aea08ed51036a9a0e2c9dfd8dac@git.kernel.org> <20090410080444.GC16512@elf.ucw.cz> <20090410103934.GA21506@elte.hu> <20090410104648.GA31516@elf.ucw.cz> <20090410112546.GD21506@elte.hu>
 <20090410113824.GA18823@elf.ucw.cz> <49E0C1AB.2050608@redhat.com> <49E17A6E.5000104@zytor.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 11 Apr 2009, H. Peter Anvin wrote:
> 
> The main thing you could do is drop or virtualize memory accesses to RAM it
> should never access in the first place, like some BIOSes which scribble over
> random locations in low memory.

Please don't.

This discussion is just taking us down a rat-hole of more complexity, and 
_way_ more fragility.

I'm absolutely willing to bet that trying to do the BIOS calls will break 
way more than it will fix. Sure, it will probably work for 99.9% of all 
BIOSes, but then it will break horribly for some BIOS that tries to do 
something "clever". SMM has already been mentioned as an example of 
something that simply isn't virtualizable.

Timing is another, very traditional, one. There used to be video BIOSes 
that simply didn't work in a dosbox-like environment because they had 
tight timing loops that were coupled to hardware. I can pretty much 
guarantee that that has gone away as far as the video BIOS is concerned, 
but the main BIOS? Who the hell knows.

Sure, none of the calls we do to the BIOS from the kernel should need 
anything fancy at all, and maybe I'm pessimistic. But at the same time, I 
really don't think the BIOS calls are worth that kind of infrastructure. 

Sure, go ahead and wrap them in some kind of "save and restore all 
registers" wrapping, but nothing fancier than that. It would just be 
overkill, and likely to break more than it fixes.

		Linus
