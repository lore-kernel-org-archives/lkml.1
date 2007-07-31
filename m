Return-Path: <linux-kernel-owner+w=401wt.eu-S1753284AbXGaP3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbXGaP3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 11:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbXGaP3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 11:29:15 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60912 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750908AbXGaP3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 11:29:14 -0400
Date: Tue, 31 Jul 2007 17:29:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Ed L. Cashin" <ecashin@coraid.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, ak@suse.de
Subject: Re: ATA over ethernet swapping and obfuscated code
Message-ID: <20070731152924.GM2087@elf.ucw.cz>
References: <20070731135831.GA4604@elf.ucw.cz> <20070731150324.GE3206@coraid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731150324.GE3206@coraid.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

(and thanks for the response).

> > I wanted to know if it is possible/okay to swap over AOE... 
> > 
> > According to
> > http://www.coraid.com/support/linux/EtherDrive-2.6-HOWTO-5.html#ss5.20
> > .. it runs OOM even during normal use, so I guess swapping over it is
> > no-no?
> 
> It can be done (e.g., to create virtual memory for running xfs_check
> on a diskless machine as a temporary measure), but it probably won't
> be a good idea until there is a mechanism that allows write responses
> to be (quickly recognized and then) received without allocating memory
> when there are no free pages.
> 
> I think if we could register a very fast function to recognize write
> responses, which would be called only when free memory was very low,
> and then use a pre-allocated receive skb for receiving write
> responses, then we'd be OK, and the common case wouldn't be
 > affected.

Is the protocol documented somewhere? aoe.txt only points at
HOWTO... aha, protocol is linked from wikipedia.
http://www.coraid.com/documents/AoEr10.txt ... perhaps that should be
linked from aoe.txt, too?

Hmm, aoe protocol is really trivial. Perhaps netpoll/netconsole
infrastructure could be used to create driver good enough for
swapping? (Ok, it would not neccessarily perform too well, but... we'd
simply wait for the reply synchronously. It should be pretty simple).


> > Can I build both client and server for these using free software?
> 
> Yes.  A popular free target is the vblade (aoetools.sourceforge.net),
> and there are others.  The most popular free software initiator is the
> aoe driver in Linux.

Good, thanks.

> > In the process, I looked at the aoe code, and parts of it look like
> > obfuscated C contest. The use of switch() as an if was particulary
> > creative; I'm not even sure if I translated it properly... can you
> > take a look?
> 
> I recently submitted a set of patches, and Andrew Morton asked me to
> avoid the switch statement you are talking about, so thanks for the
> patch, but that code is going to be patched soon anyway.

Sorry for the noise. I was blind, the spin_unlock issue is not there
and I should have looked at -mm.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
