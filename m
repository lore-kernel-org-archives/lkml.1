Return-Path: <linux-kernel-owner+w=401wt.eu-S1755038AbZJRSEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbZJRSEm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 14:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754966AbZJRSEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 14:04:41 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37870 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960AbZJRSEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 14:04:40 -0400
Date: Sat, 17 Oct 2009 18:40:42 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nix <nix@esperi.org.uk>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Fulghum <paulkf@microgate.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Boyan <btanastasov@yahoo.co.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       "Fr?d?ric L. W. Meunier" <fredlwm@gmail.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
Message-ID: <20091017164042.GC1423@ucw.cz>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <L6tb-VyKHZK.A.PaB.Ozl0KB@chimera> <C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com> <87ljjgfcbu.fsf@spindle.srvr.nix> <alpine.LFD.2.01.0910121703390.3438@localhost.localdomain> <alpine.LFD.2.01.0910122004200.3438@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910122004200.3438@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Comments? Does this work? Does it make any difference? It seems fairly 
> unlikely, but it's the only obvious problem I've seen in the tty buffering 
> code so far.
> 
> And that code is literally 3 years old, and it seems unlikely that a 
> regular _keyboard_ buffer would be able to hit the (rather small) race 
> condition. But other serialization may have hidden it, and timing 
> differences could certainly have caused it to trigger much more easily.

I use this (run as root) to trigger various problems in this
area... (portable between i386 and i386).

								Pavel

void
main(void)
{
	int i;
	iopl(3);
	while (1) {
		asm volatile("cli");
		//		for (i=0; i<20000000; i++)
		for (i=0; i<1000000000; i++)
			asm volatile("");
		asm volatile("sti");
		sleep(1);
	}
}


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
