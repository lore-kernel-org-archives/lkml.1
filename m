Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbYIXOmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbYIXOmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 10:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbYIXOmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 10:42:24 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:39149 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733AbYIXOmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 10:42:24 -0400
Date: Wed, 24 Sep 2008 16:35:27 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] atmel-mci: support multiple mmc slots
Message-ID: <20080924163527.30cfc223@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080923211222.551389ab@mjolnir.drzeus.cx>
References: <1222101497-21183-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1222101497-21183-2-git-send-email-haavard.skinnemoen@atmel.com>
	<1222101497-21183-3-git-send-email-haavard.skinnemoen@atmel.com>
	<1222101497-21183-4-git-send-email-haavard.skinnemoen@atmel.com>
	<20080923195342.52b1164d@mjolnir.drzeus.cx>
	<20080923201650.4525b883@hskinnemo-gx745.norway.atmel.com>
	<20080923211222.551389ab@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 24 Sep 2008 14:35:15.0117 (UTC) FILETIME=[C234EDD0:01C91E52]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> On Tue, 23 Sep 2008 20:16:50 +0200
> Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
> 
> > Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> > > 
> > > You forgot the most important part; how to handle the clock given two
> > > different requests.
> > 
> > I don't think I did. The set_ios() function merely calculates the value
> > of MR and stashes it away. It isn't written to the controller until
> > after the host has been claimed for a request.
> > 
> 
> I see... It still doesn't take into account conflicting clocks. Or does
> the multiplexer disable the clock for the inactive slot?

On AP7000, the clock line is shared. Do I have to run the clock at the
minimum of the two slots' maximum rates, or does it only matter when
the card is being accessed?

> > > (This will also get a bit more painful when/if the core starts
> > > disabling the clock when a card is idle)
> > 
> > The atmel-mci driver already stops the clock between requests.
> 
> Then I expect a patch to remove that. Fiddling with the clock is
> dangerous and I've seen everything from hung cards to silently broken
> writes when you disable the clock too early after a request.

Ok. I'll see if I can fix that -- I take it you want a patch for
2.6.27, then?

> > Though I don't understand why the core would care about clocks.
> > 
> 
> Power management. But it needs to be handled centrally. Primarily
> because of the reason above, but you might also have such things as
> SDIO functions requiring the clock to be on.

I see.

> > > 
> > > Fall back to polling?
> > 
> > Probably, yes. Can I fall back to polling after the host has been
> > registered?
> > 
> 
> Hmm... no. Not sure how to handle this...

I'll see if I can figure out a way to do it. I'm not giving it high
priority since it's a fairly obscure error case which shouldn't happen
with properly implemented board code.

Haavard
