Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245AbYIQOu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbYIQOu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 10:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752736AbYIQOuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 10:50:16 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42863 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752640AbYIQOuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 10:50:15 -0400
X-Sasl-enc: 2T/lR2ZchlTIrnIirXWuqbMObUw+jscTH2xtT8VaQkr1 1221663013
Date: Wed, 17 Sep 2008 11:50:08 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Michael Buesch <mb@bu3sch.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Adel Gadllah <adel.gadllah@gmail.com>,
       wireless <linux-wireless@vger.kernel.org>, bcm43xx-dev@lists.berlios.de,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression in 2.6.27-rcX caused by commit
	bc19d6e0b74ef03a3baf035412c95192b54dfc6f
Message-ID: <20080917145007.GA5186@khazad-dum.debian.net>
References: <48CFC03A.8020708@lwfinger.net> <48D0095B.40403@lwfinger.net> <20080916233240.GA18574@srcf.ucam.org> <200809171622.55882.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809171622.55882.mb@bu3sch.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2008, Michael Buesch wrote:
> On Wednesday 17 September 2008 01:32:40 Matthew Garrett wrote:
> > On Tue, Sep 16, 2008 at 02:30:35PM -0500, Larry Finger wrote:
> > 
> > > I didn't say it was not possible. What I said is that _ONLY_ the
> > > operator's finger could change the state, just like in your laptop.
> > > Thus it makes absolutely no difference what state RFKILL thinks it is
> > > in.
> > 
> > Of course it makes a difference. The reason why two states are provided 
> > is to allow userspace to distinguish whether it can unblock the device 
> > or not. It's clear that b43's rfkill code is astonishingly broken (and 
> > that's not a criticism of anyone involved - the documentation's 
> > confusing and there weren't any good examples of how it should be 
> > implemented).
> > 
> > The real question is how the LED state is supposed to be being toggled, 
> > and what that's got to do with rfkill. I /think/ that the current state 
> > of events is:
> 
> Read the rfkill code. It toggles a LED trigger if the state changes from
> UNBLOCKED to BLOCKED. b43 uses that trigger to run the radio LED.
> 
> > 1) User toggles state
> > 2) b43 changes rfkill state (by using rfkill_force_state). The LED state 
> > should also be changed in the process.
> 
> No it shouldn't. LEDs are entirely handled by triggers. We must _never_ toggle
> the LED state from within b43 directly via hardcoded stuff.
> rfkill is responsible for handling the radio LEDs in the machine.

He means rfkill_force_state() should change the LED state in the process,
which it isn't doing.

It is an one-line patch, I am testing it now.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
