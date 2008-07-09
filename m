Return-Path: <linux-kernel-owner+w=401wt.eu-S1756910AbYGIVMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbYGIVMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755834AbYGIVMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:12:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48354 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755663AbYGIVMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:12:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: request_firmware vs. resume (was Re: [PATCH] bnx2 - use request_firmware())
Date: Wed, 9 Jul 2008 23:13:54 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: David Miller <davem@davemloft.net>, alan@lxorguk.ukuu.org.uk,
       mchan@broadcom.com, dwmw2@infradead.org, bastian@waldi.eu.org,
       linux-kernel@vger.kernel.org
References: <20080707221950.3dfba435@the-village.bc.nu> <20080708.015838.245133409.davem@davemloft.net> <20080709202547.GD11006@ucw.cz>
In-Reply-To: <20080709202547.GD11006@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807092313.55777.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 9 of July 2008, Pavel Machek wrote:
> Hi!
> 
> > > > The firmware needs to be reloaded every time the chip resets.
> > > > You're not saving anything/
> > > 
> > > > See above, you aren't saving anything.  The firmware needs to stay
> > > > around so it can be reloaded into the card during exceptions.
> > > > 
> > > > That is, unless you want a more failure prone system.
> > > 
> > > Ok so if tg3 always needs the same firmware and always needs it in memory
> > > then maybe it isn't a significant candidate for request_firmware beyond
> > > the neatness of distribution. I note the firmware hasn't changed in years
> > > so it can easily be shipped separately and the one package would have
> > > done for all this time.
> > 
> > It isn't just tg3.  All the broadcom gigabit chips need this
> > kind of handling.
> > 
> > Basically all of the drivers we are pushing back on.
> > 
> > I bet there are other similar examples.
> 
> Be careful about request_firmware. Doing it right w.r.t.
> suspend/resume is quite tricky: you have to load it from userspace
> before kernel starts, so that you can use it during resume...

Rather, you have to cache it in memory before your ->suspend() is invoked.

Thanks,
Rafael
