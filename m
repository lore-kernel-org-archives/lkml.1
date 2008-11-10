Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbYKJXfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbYKJXfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 18:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbYKJXfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 18:35:43 -0500
Received: from gate.crashing.org ([63.228.1.57]:47198 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbYKJXfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 18:35:42 -0500
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
In-Reply-To: <jefxlzi2x0.fsf@sykes.suse.de>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
	 <wnN9HICUAgP.A._d.f5zFJB@chimera> <1226295985.7731.7.camel@pasglop>
	 <jetzafiad4.fsf@sykes.suse.de> <1226353979.7530.8.camel@pasglop>
	 <jefxlzi2x0.fsf@sykes.suse.de>
Content-Type: text/plain
Date: Tue, 11 Nov 2008 10:34:54 +1100
Message-Id: <1226360094.7530.18.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> There seems to be some race involved here.  I cannot reproduce the
> problem ATM.

I wonder if it's related to the new acceleration at all then.

I've tried various suspend/resume cycles in straight console mode using
directly snooze -f (kernel ioctl) and from X using ubuntu intrepid and
gnome power manager and it worked fine on a 5,6 which should be fairly
similar to your 6,7 I think.

It's possible that there's yet another X related race though. I've seen
cases of X whacking the chip -after- it has religuished the console back
to the kernel (back to KD_TEXT) in the past which is very wrong, though
I didn't spot that during my testing, there could be some race lurking
there.

Can you describe your problem more precisely ? I didn't see (or forgot)
your initial report. Did it crash on suspend or wakeup ? what symptoms ?

Note also that on PowerBooks, there's a platform hook that allows
radeonfb to wake up the video chip _very_ early, thus allowing easier
debugging of the boot process, so even races like that on wakeup would
surprise me since we do wakup up the chip before we even get a chance to
schedule userspace again (in fact before we even bring back the L2
cache !)  

Cheers,
Ben.


