Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbZGJK3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbZGJK3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 06:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbZGJK3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 06:29:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58059 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbZGJK3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 06:29:36 -0400
Date: Fri, 10 Jul 2009 12:28:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Boot Consoles question...
Message-ID: <20090710102857.GF5499@elte.hu>
References: <200907040017.26921.rgetz@blackfin.uclinux.org> <20090704102904.GB32257@elte.hu> <200907041207.42388.rgetz@blackfin.uclinux.org> <200907071949.41311.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907071949.41311.rgetz@blackfin.uclinux.org>
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


* Robin Getz <rgetz@blackfin.uclinux.org> wrote:

> On Sat 4 Jul 2009 12:07, Robin Getz pondered:
> > On Sat 4 Jul 2009 06:29, Ingo Molnar pondered:
> > > Could be changed i guess ... but is it really an issue?
> > 
> > It is just a change from "normal" (when the kernel has no boot console).
> > 
> > >  One artifact 
> > >  could be manual scroll-back - it would perhaps be nice indeed to
> > >  allow the scrollback to the top of the bootlog.
> > 
> > Exactly.
> > 
> > One of my thoughts (was since CON_PRINTBUFFER isn't used after 
> > register_console()) - was for the CON_BOOT's CON_PRINTBUFFER flag to control 
> > the clearing of the CON_PRINTBUFFER for the real console or not...
> > 
> > All early_printk consoles that I looked at have their CON_PRINTBUFFER set.
> > 
> > Which means that something like should do the trick -- allow people who want 
> > to override things to do so, and still have the today's setup work as is...
> 
> I guess no one liked that idea?

No, this means no-one objected :)

> How about at least making sure that the real console gets a 
> message that something is on the bootconsole? Right now the switch 
> message:
> 
> console handover:boot [early_shadow0]  -> real [ttyBF0]
> 
> only is printed on the bootconsole, not on the real console - so 
> someone looking at the real console may not know there is anything 
> on the boot console. They just think that things are missing...

Mind sending a full (changelogged, titled, etc.) patch for the other 
bit as well? It kind of overlaps this one but both make sense, 
especially if people end up objecting against the more intrusive one 
and it gets dropped/reverted ;-)

	Ingo
