Return-Path: <linux-kernel-owner+w=401wt.eu-S1762165AbZFPTnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762165AbZFPTnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 15:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbZFPTnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 15:43:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57578 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbZFPTno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 15:43:44 -0400
Date: Tue, 16 Jun 2009 21:43:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [bug] WARNING: at drivers/char/tty_io.c:1266
	tty_open+0x1ea/0x388()
Message-ID: <20090616194332.GC12699@elte.hu>
References: <20090614081052.GA9276@elte.hu> <20090614115428.1127ed2d@lxorguk.ukuu.org.uk> <20090616071057.GA29862@elte.hu> <20090616094430.75bbbee2@lxorguk.ukuu.org.uk> <20090616084952.GA18263@elte.hu> <20090616100052.038f9d24@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616100052.038f9d24@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > I'm wondering, how long have these patches been in linux-next? 
> > Has no-one reported an easy (or easier) reproducer than a plain 
> > bootup (which really doesnt hit the tty code intentionally 
> > hard)?
> 
> Quite a while - and the open side stuff hasn't changed in the post 
> 2.6.30 patches at all. Your box seems to show stuff up that most 
> users just don't hit.

Another box has triggered that too btw. But with your two fixes:

 69e8fd4: tty: fix sanity check
 9f7a9ce: ldisc: Make sure the ldisc isn't active when we close it

i havent seen any new tty warnings today. (testing is a bit spotty 
due to other bugs though - this is typical of the merge window.)

Also, the only warning that remained after your fix was the new 
warning you added to catch an old bug - that's not a regression 
really.

> > You should probably also write testcases and stress-tests if you 
> > modify code in this area.
> 
> I did - they hang the tty layers in 2.6.30 and earlier in about 60 
> seconds, it then corrupts the module counts and dies shortly 
> after. I've not published them because they can obviously be 
> seriously misused.

Too bad - i could have ran them in the test mix.

> I don't have the luxury of building on solid foundations trying to 
> sort the tty layer out - its been broken since 2.1.x when the 
> lock_kernel logic stopped applying to IRQ handlers.

No complaints from me at all! You are doing fantastic cleanups and 
fixes in the TTY code.

	Ingo
