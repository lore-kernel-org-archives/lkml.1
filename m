Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbYKCUX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbYKCUX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 15:23:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755883AbYKCUXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 15:23:33 -0500
Received: from gate.crashing.org ([63.228.1.57]:57119 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755803AbYKCUXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 15:23:31 -0500
Subject: Re: [Linux-fbdev-devel] radeonfb lockup in .28-rc (bisected)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: James Cloos <cloos@jhcloos.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Krzysztof Halasa <khc@pm.waw.pl>
In-Reply-To: <m33ai8akoo.fsf@lugabout.jhcloos.org>
References: <m31vy1k3ea.fsf@lugabout.jhcloos.org>
	 <1225152347.8004.49.camel@pasglop> <m3k5bt2hsc.fsf@lugabout.jhcloos.org>
	 <1225662539.8004.237.camel@pasglop>  <m33ai8akoo.fsf@lugabout.jhcloos.org>
Content-Type: text/plain
Date: Tue, 04 Nov 2008 07:22:34 +1100
Message-Id: <1225743754.8004.260.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-03 at 10:33 -0500, James Cloos wrote:
> >>>>> "Benjamin" == Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:
> 
> >> is in play.  It is probably spinning through all of the 2000000 possible
> >> udelay(10) calls.  I don't think I ever gave it twenty seconds before
> >> giving up.  And certainly not forty seconds, if the freeze happens after
> >> setting the DST_Y_X register.
> 
> Benjamin> Well, setting DST_Y_X is what triggers the transfer. The above
> Benjamin> means that the FIFO isn't emptying (ie, the engine is locked up).
> 
> I gave it another try over the weekend and let it sit for five minutes.
> The reset message never appeared.

Because it's probably going to lockup trying to display it :-) I need to
make that stuff a bit more robust, by disabling acceleration if the
engine locks up for example.

> Again, that is fine by me.  Otherwise I'll just leave the #if0 commit
> in my compile clone.

Allright, we'll see what I come up with, and at worst, I'll just revert
the whole thing.

Ben.


