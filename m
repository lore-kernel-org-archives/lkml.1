Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbZI3VtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbZI3VtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 17:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbZI3VtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 17:49:04 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:55527 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752083AbZI3VtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 17:49:03 -0400
From: Frans Pop <elendil@planet.nl>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [.32-rc1/2] ath5k: has become unreliable with .32-rc1
Date: Wed, 30 Sep 2009 23:49:04 +0200
User-Agent: KMail/1.9.9
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200909300952.29106.elendil@planet.nl> <20090930122451.GA17280@hash.localnet>
In-Reply-To: <20090930122451.GA17280@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909302349.05614.elendil@planet.nl>
X-OriginalArrivalTime: 30 Sep 2009 21:49:05.0743 (UTC) FILETIME=[D4EC7DF0:01CA4217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 September 2009, Bob Copeland wrote:
> On Wed, Sep 30, 2009 at 09:52:27AM +0200, Frans Pop wrote:
> > This is on a laptop I don't use much, but with .31 wireless has always
> > been (and still is) reliable (.31-rc5 is the last kernel I built for
> > it). On my other laptop wireless (iwlagn) works fine with .32-rc1.
>
> Although iwlagn works, I would think this kind of thing:
> > ath0: authenticated
> > ath0: associate with AP 00:14:c1:38:e5:15 (try 1)
> > ath0: RX ReassocResp from 00:14:c1:38:e5:15 (capab=0x411 status=0 aid=2)
> > ath0: associated 
> > ath0: deauthenticating by local choice (reason=3)
>
> ...is some kind of issue with userspace or wext rather than the driver.
> Ath5k only had a dozen or so patches this time around, so it should be
> easy to bisect if it's a problem in the driver.  One possibility is
> hardware CCMP support but I've been using it here for some time.

I doubt it's a userspace issue, but it does look like the regression was
not triggered by the ath5k driver itself. In the mean time I did a bisect
on the drivers/net/wireless/ath directory without any results.

> By the way, name it what you will, but the standard is wlan0 these days
> :)

Yep. A leftover from the days I used madwifi :-) I kind of like it though
given its similarity to eth0.

> > So the difference looks to be how I boot: if I do a *cold* boot
> > directly into .32, wireless fails; if I *reboot* from .31 into .32,
> > wireless comes up correctly. Reboot from .32 to .32 fails too.
>
> Is that repeatable?

Yes, 100%. Weird heh? That's what made me think it must be an ath5k
driver issue as it looks like a hardware initialization problem. Could
be PCI or PCMCIA though, although I don't see anything suspicious in
dmesg.

> Rafael J. Wysocki has a patch floating around to fix PCMCIA resume,
> linked here: http://bugzilla.kernel.org/show_bug.cgi?id=13092

Ack.

I'll probably wait and see how -rc2 (or 2a or 3 or whatever) behaves
before doing a full bisect, but I will come back to this.

Thanks,
FJP
