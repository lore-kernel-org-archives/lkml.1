Return-Path: <linux-kernel-owner+w=401wt.eu-S1754418AbZI3MZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbZI3MZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 08:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbZI3MZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 08:25:10 -0400
Received: from mail.deathmatch.net ([72.66.92.28]:2474 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbZI3MZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 08:25:09 -0400
Date: Wed, 30 Sep 2009 08:24:51 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [.32-rc1/2] ath5k: has become unreliable with .32-rc1
Message-ID: <20090930122451.GA17280@hash.localnet>
References: <200909300952.29106.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909300952.29106.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 09:52:27AM +0200, Frans Pop wrote:
> This is on a laptop I don't use much, but with .31 wireless has always
> been (and still is) reliable (.31-rc5 is the last kernel I built for it).
> On my other laptop wireless (iwlagn) works fine with .32-rc1.

Although iwlagn works, I would think this kind of thing:

> ath0: authenticated
> ath0: associate with AP 00:14:c1:38:e5:15 (try 1)
> ath0: RX ReassocResp from 00:14:c1:38:e5:15 (capab=0x411 status=0 aid=2)
> ath0: associated
> ath0: deauthenticating by local choice (reason=3)
> ath0: direct probe to AP 00:14:c1:38:e5:15 (try 1)
> ath0 direct probe responded
> ath0: authenticate with AP 00:14:c1:38:e5:15 (try 1)
> ath0: authenticated
> ath0: associate with AP 00:14:c1:38:e5:15 (try 1)
> ath0: RX ReassocResp from 00:14:c1:38:e5:15 (capab=0x411 status=0 aid=2)

...is some kind of issue with userspace or wext rather than the driver.
Ath5k only had a dozen or so patches this time around, so it should be
easy to bisect if it's a problem in the driver.  One possibility is
hardware CCMP support but I've been using it here for some time.

By the way, name it what you will, but the standard is wlan0 these days :)

> So the difference looks to be how I boot: if I do a *cold* boot directly
> into .32, wireless fails; if I *reboot* from .31 into .32, wireless
> comes up correctly. Reboot from .32 to .32 fails too.

Is that repeatable?

Rafael J. Wysocki has a patch floating around to fix PCMCIA resume,
linked here: http://bugzilla.kernel.org/show_bug.cgi?id=13092

-- 
Bob Copeland %% www.bobcopeland.com

