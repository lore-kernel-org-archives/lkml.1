Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbYKKBuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbYKKBuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 20:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbYKKBuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 20:50:35 -0500
Received: from gate.crashing.org ([63.228.1.57]:40281 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbYKKBue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 20:50:34 -0500
Subject: Re: [Bug #11875] radeonfb lockup in .28-rc (bisected)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andreas Schwab <schwab@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       James Cloos <cloos@jhcloos.com>,
       Paul Collins <paul@burly.ondioline.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <je1vxji1br.fsf@sykes.suse.de>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
	 <wnN9HICUAgP.A._d.f5zFJB@chimera> <1226295985.7731.7.camel@pasglop>
	 <jetzafiad4.fsf@sykes.suse.de> <1226353979.7530.8.camel@pasglop>
	 <jefxlzi2x0.fsf@sykes.suse.de> <1226360094.7530.18.camel@pasglop>
	 <je1vxji1br.fsf@sykes.suse.de>
Content-Type: text/plain
Date: Tue, 11 Nov 2008 12:49:34 +1100
Message-Id: <1226368174.7530.47.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-11 at 00:54 +0100, Andreas Schwab wrote:
> 
> > Can you describe your problem more precisely ?
> 
> It crashes during suspend (after the console was switched away from X),
> but I can only see a frame buffer with apparently random contents when
> it happens.  When suspend works then those random frame buffer contents
> are only briefly visible before the screen is cleared.

Does it actually switches away from X ?

IE. You see the console before the crap on console or not ?

I've seen what you describe happening when doing snooze -f (direct
kernel ioctl) straight from within X. It seems to me that the problem
was that for some reason it didn't switch the console, which would
definitely make it crash. I need to double check what's up, it's
possible that the kernel fails to switch it properly or fails to wait
for X to ack the switch.

In any case, I doesn't seem to be directly related to those radeonfb
changes, though a clash with X like that is indeed more likely to
actually happen if radeonfb relies more heavily on acceleration.

I'll have a look later today at the console switch from X in the kernel
see if it's been broken in a way or another.

Note: I just did some tests using both echo "mem" >/sys/power/state and
snooze -f and it worked fine. IE, the console switch away from X worked.
So while I think I observed your problem once, I also cannot reproduce
it now.

I wonder if there's a race condition in the VT switch. It's possible
that it could be yet another case of X whacking the chip after it has
effectively relinguished control of the VT to the kernel, or it could be
a kernel race.

Cheers,
Ben.


