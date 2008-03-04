Return-Path: <linux-kernel-owner+w=401wt.eu-S1760738AbYCDKAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760738AbYCDKAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 05:00:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbYCDKAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 05:00:09 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:55174 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbYCDKAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 05:00:08 -0500
Date: Tue, 4 Mar 2008 10:58:41 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: David Brownell <david-b@pacbell.net>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Bugs in MMC [was: [Bug 10030] Suspend doesn't work when SD card
 is inserted]
Message-ID: <20080304105841.6c951665@mjolnir.drzeus.cx>
In-Reply-To: <200803040144.09601.david-b@pacbell.net>
References: <200802241500.41969.rjw@sisk.pl>
	<200803031359.38263.david-b@pacbell.net>
	<20080304070357.61ee825b@mjolnir.drzeus.cx>
	<200803040144.09601.david-b@pacbell.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008 01:44:09 -0800
David Brownell <david-b@pacbell.net> wrote:

> On Monday 03 March 2008, Pierre Ossman wrote:
> > On Mon, 3 Mar 2008 13:59:37 -0800
> > David Brownell <david-b@pacbell.net> wrote:
> > 
> > > 
> > > Card insert/remove events can be system wake events though.  Which
> > > makes that restriction impractical.
> 
> This part seems to be ignored by your comment ... wake events.
>

How so? How is a wake caused by the MMC controller different than any other source?

> 
> That is, the MMC core doesn't understand wakeup events.
> 
> Or, as pointed out elsewhere, well-behaved MMC hosts ... which don't
> need either such reprobing or the associated remove-on-suspend.
> 

You need well behaved _systems_, not just hosts to achieve that guarantee. SDHCI controllers have the ability to wake up the system on card removal, but there is zero guarantee that the platform actually wired the controller up in a way that actually allows it to do this. Throw suspend to disk, where the system might completely lose power, into the mix and you're completely screwed.

So for the default behaviour to change, we need one of two things:

- Certainty that removals cannot go unnoticed. (even then, you also need wakeup latency guarantees)
- Ability to detect a removal after the fact.

For the general case, the first one is impossible given todays hardware. The second might be solvable, but noone has done the work.

(If your complete system can satisfy the first option, feel free to add the "unsafe" option to you defconfig, but that is hardly adequate reason to have it on by default.)

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
