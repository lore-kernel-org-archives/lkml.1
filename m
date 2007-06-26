Return-Path: <linux-kernel-owner+w=401wt.eu-S1757802AbXFZOqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802AbXFZOqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 10:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755940AbXFZOqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 10:46:07 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:53743
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbXFZOqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 10:46:06 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] hw_random: add quality categories
Date: Tue, 26 Jun 2007 16:45:24 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200706241555.22957.mb@bu3sch.de> <200706261612.27184.mb@bu3sch.de> <20070626143237.GF11115@waste.org>
In-Reply-To: <20070626143237.GF11115@waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706261645.24360.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 June 2007 16:32:37 Matt Mackall wrote:
> > No wait. You are missing the whole point of this
> > quality category.
> > The whole point of it is to prevent defaulting to a bad RNG, if
> > there's a bad and a good one in a machine.
> > Well, what's bad.
> > It's easy. HWRNGs like the one in bcm43xx are bad.
> > It's proprietary and nobody knows what it does (I guess
> > it gathers the entropy from the network or something
> > and hashes that in hardware).
> > So such a device would be QUAL_LOW.
> 
> If it's gathering its entropy from the network, it is not a QUAL_LOW
> RNG because it is not a hardware random number generator at all!
> 
> Such a device is QUAL_PSEUDO or QUAL_UNKNOWN. If it's known or
> suspected to be bogus, it should be so marked. 

No, it should not be marked pseudo. It _is_ a RNG in hardware.
Where it gets its entropy from is unknown. (I'm just guessing
around).
PSEUDO is for example for entropy gathered from hardware sensors.
That's not a RNG (so pseudo) and it's even worse than the proprietary
bcm43xx thing. So bcm43xx(LOW) would win the default over the sensor.
But if there's a RNG in the CPU, it would win over bcm43xx.
And an extension board would win over the CPU.
Yeah, the extension board could in fact produce worse entropy than
the in-CPU thing. If that's the case, remove it from the machine
(or disable it in the sysfs interface).

> Once you've merged your LOW class with PSEUDO, you're left with a
> meaningless, unquantifiable distinction between NORMAL and HIGH.

No, that's not true. I explained the difference to you and it's even
explained in the kdoc help text. Re-read it, please.
HIGH is for seperate dedicated extension devices that you buy and
stick into your machine. So it would default to that, as you want
to use that by default (why would you otherwise stick it in).

To say it again: It all is _just_ for defining a sane _default_
policy. That's all.
Currently the policy is: "Select whatever comes first", which is
random. So it could select crap (bcm43xx) over not-so-crap (in-CPU-RNG).

-- 
Greetings Michael.
