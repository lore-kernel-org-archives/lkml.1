Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbYIYNw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbYIYNw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 09:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbYIYNwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 09:52:18 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:60820 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823AbYIYNwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 09:52:17 -0400
Date: Thu, 25 Sep 2008 15:51:49 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] atmel-mci: support multiple mmc slots
Message-ID: <20080925155149.173dde16@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080925090556.44940c89@mjolnir.drzeus.cx>
References: <1222101497-21183-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1222101497-21183-2-git-send-email-haavard.skinnemoen@atmel.com>
	<1222101497-21183-3-git-send-email-haavard.skinnemoen@atmel.com>
	<1222101497-21183-4-git-send-email-haavard.skinnemoen@atmel.com>
	<20080923195342.52b1164d@mjolnir.drzeus.cx>
	<20080923201650.4525b883@hskinnemo-gx745.norway.atmel.com>
	<20080923211222.551389ab@mjolnir.drzeus.cx>
	<20080924163527.30cfc223@hskinnemo-gx745.norway.atmel.com>
	<20080925090556.44940c89@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 25 Sep 2008 13:51:36.0317 (UTC) FILETIME=[D3B182D0:01C91F15]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> On Wed, 24 Sep 2008 16:35:27 +0200
> Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
> 
> > 
> > On AP7000, the clock line is shared. Do I have to run the clock at the
> > minimum of the two slots' maximum rates, or does it only matter when
> > the card is being accessed?
> > 
> 
> I'd say always. I'd never dare overclock something that's powered, even
> if we're not currently communicating with it.

Ok.

> Remember to deal with the case of a powered but unclocked card. This
> will primarily happen during card init, but it could should up later as
> well if we start implementing aggressive power management.

Ok, but how _do_ I deal with that? If the clock is turned off due to
power management, it should be safe to leave it running at the same
rate. But how about initialization? Should I stall the queue until the
newly-powered card gets a clock rate?

> > > > > (This will also get a bit more painful when/if the core starts
> > > > > disabling the clock when a card is idle)
> > > > 
> > > > The atmel-mci driver already stops the clock between requests.
> > > 
> > > Then I expect a patch to remove that. Fiddling with the clock is
> > > dangerous and I've seen everything from hung cards to silently broken
> > > writes when you disable the clock too early after a request.
> > 
> > Ok. I'll see if I can fix that -- I take it you want a patch for
> > 2.6.27, then?
> > 
> 
> .28 should be fine. It's a pretty uncommon bug.

Ok, good. A change like that needs quite extensive testing.

Btw, I just noticed that other thread about pxamci clock management.
Will it cause problems if the clock stops briefly from time to time?
Currently, the controller stops the clock if the FIFO gets full/empty
during transfer -- this is configurable, but I'd much rather let the
clock stop than risk FIFO overruns/underruns...

Haavard
