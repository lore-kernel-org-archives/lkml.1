Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbZFPIuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbZFPIuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbZFPIuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:50:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56358 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbZFPIuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:50:05 -0400
Date: Tue, 16 Jun 2009 10:49:52 +0200
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
Message-ID: <20090616084952.GA18263@elte.hu>
References: <20090614081052.GA9276@elte.hu> <20090614115428.1127ed2d@lxorguk.ukuu.org.uk> <20090616071057.GA29862@elte.hu> <20090616094430.75bbbee2@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616094430.75bbbee2@lxorguk.ukuu.org.uk>
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

> > > I split the ldisc and tty apart and redid the ldisc locking so its a fair
> > > bet I know what changeset is to blame, will just need to hunt it down a
> > > bit. kmemcheck found one leak case on Friday which I've fixed but not yet
> > > scribbles.
> > > 
> > > >  c65c9bc: tty: rewrite the ldisc locking
> > > 
> > > Almost certainly that one and will investigate on Monday
> > 
> > I have applied your patch from yesterday (attached further below for 
> > reference) and the SLAB corruption has not triggered - instead i'm 
> > now getting this warning, after 96 reboots:
> 
> That's progress
> 
> > Another test-box has produced this warning too. (Same config and 
> > same hw as i sent the details for earlier in this thread.)
> > 
> > So there's still something fishy going on.
> 
> Are you using a standard udev/fedora setup or something different 
> (I know the devtmpfs proposal stuff produces crashes like that one 
> all the time which are not seen anywhere else)
> 
> And is it reproducable this time - and always 96 ?

It shows up randomly and on multiple systems.

I'm wondering, how long have these patches been in linux-next? Has 
no-one reported an easy (or easier) reproducer than a plain bootup 
(which really doesnt hit the tty code intentionally hard)?

You should probably also write testcases and stress-tests if you 
modify code in this area.

	Ingo
