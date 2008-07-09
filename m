Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbYGIU4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbYGIU4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:56:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbYGIUzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:55:36 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1523 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755364AbYGIUzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:55:35 -0400
Date: Wed, 9 Jul 2008 22:25:47 +0200
From: Pavel Machek <pavel@suse.cz>
To: David Miller <davem@davemloft.net>
Cc: alan@lxorguk.ukuu.org.uk, mchan@broadcom.com, dwmw2@infradead.org,
       bastian@waldi.eu.org, linux-kernel@vger.kernel.org
Subject: request_firmware vs. resume (was Re: [PATCH] bnx2 - use request_firmware())
Message-ID: <20080709202547.GD11006@ucw.cz>
References: <20080707221950.3dfba435@the-village.bc.nu> <20080707.150549.242704515.davem@davemloft.net> <20080708073922.6c2470c1@the-village.bc.nu> <20080708.015838.245133409.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080708.015838.245133409.davem@davemloft.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > The firmware needs to be reloaded every time the chip resets.
> > > You're not saving anything/
> > 
> > > See above, you aren't saving anything.  The firmware needs to stay
> > > around so it can be reloaded into the card during exceptions.
> > > 
> > > That is, unless you want a more failure prone system.
> > 
> > Ok so if tg3 always needs the same firmware and always needs it in memory
> > then maybe it isn't a significant candidate for request_firmware beyond
> > the neatness of distribution. I note the firmware hasn't changed in years
> > so it can easily be shipped separately and the one package would have
> > done for all this time.
> 
> It isn't just tg3.  All the broadcom gigabit chips need this
> kind of handling.
> 
> Basically all of the drivers we are pushing back on.
> 
> I bet there are other similar examples.

Be careful about request_firmware. Doing it right w.r.t.
suspend/resume is quite tricky: you have to load it from userspace
before kernel starts, so that you can use it during resume...

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
