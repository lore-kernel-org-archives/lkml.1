Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbZFPJA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbZFPJA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 05:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbZFPJAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 05:00:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40464 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752096AbZFPJAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 05:00:20 -0400
Date: Tue, 16 Jun 2009 10:00:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [bug] WARNING: at drivers/char/tty_io.c:1266
 tty_open+0x1ea/0x388()
Message-ID: <20090616100052.038f9d24@lxorguk.ukuu.org.uk>
In-Reply-To: <20090616084952.GA18263@elte.hu>
References: <20090614081052.GA9276@elte.hu>
	<20090614115428.1127ed2d@lxorguk.ukuu.org.uk>
	<20090616071057.GA29862@elte.hu>
	<20090616094430.75bbbee2@lxorguk.ukuu.org.uk>
	<20090616084952.GA18263@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm wondering, how long have these patches been in linux-next? Has 
> no-one reported an easy (or easier) reproducer than a plain bootup 
> (which really doesnt hit the tty code intentionally hard)?

Quite a while - and the open side stuff hasn't changed in the post 2.6.30
patches at all. Your box seems to show stuff up that most users just
don't hit.
 
> You should probably also write testcases and stress-tests if you 
> modify code in this area.

I did - they hang the tty layers in 2.6.30 and earlier in about 60
seconds, it then corrupts the module counts and dies shortly after. I've
not published them because they can obviously be seriously misused.

I don't have the luxury of building on solid foundations trying to sort
the tty layer out - its been broken since 2.1.x when the lock_kernel
logic stopped applying to IRQ handlers.

Alan
