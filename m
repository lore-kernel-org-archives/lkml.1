Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbYIQOX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbYIQOX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 10:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbYIQOXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 10:23:20 -0400
Received: from bu3sch.de ([62.75.166.246]:44614 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875AbYIQOXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 10:23:19 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: Regression in 2.6.27-rcX caused by commit bc19d6e0b74ef03a3baf035412c95192b54dfc6f
Date: Wed, 17 Sep 2008 16:22:55 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Adel Gadllah <adel.gadllah@gmail.com>,
       wireless <linux-wireless@vger.kernel.org>, bcm43xx-dev@lists.berlios.de,
       LKML <linux-kernel@vger.kernel.org>
References: <48CFC03A.8020708@lwfinger.net> <48D0095B.40403@lwfinger.net> <20080916233240.GA18574@srcf.ucam.org>
In-Reply-To: <20080916233240.GA18574@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809171622.55882.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 September 2008 01:32:40 Matthew Garrett wrote:
> On Tue, Sep 16, 2008 at 02:30:35PM -0500, Larry Finger wrote:
> 
> > I didn't say it was not possible. What I said is that _ONLY_ the
> > operator's finger could change the state, just like in your laptop.
> > Thus it makes absolutely no difference what state RFKILL thinks it is
> > in.
> 
> Of course it makes a difference. The reason why two states are provided 
> is to allow userspace to distinguish whether it can unblock the device 
> or not. It's clear that b43's rfkill code is astonishingly broken (and 
> that's not a criticism of anyone involved - the documentation's 
> confusing and there weren't any good examples of how it should be 
> implemented).
> 
> The real question is how the LED state is supposed to be being toggled, 
> and what that's got to do with rfkill. I /think/ that the current state 
> of events is:

Read the rfkill code. It toggles a LED trigger if the state changes from
UNBLOCKED to BLOCKED. b43 uses that trigger to run the radio LED.

> 1) User toggles state
> 2) b43 changes rfkill state (by using rfkill_force_state). The LED state 
> should also be changed in the process.

No it shouldn't. LEDs are entirely handled by triggers. We must _never_ toggle
the LED state from within b43 directly via hardcoded stuff.
rfkill is responsible for handling the radio LEDs in the machine.

-- 
Greetings Michael.
