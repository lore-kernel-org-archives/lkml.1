Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbXF0MxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbXF0MxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 08:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758211AbXF0Mwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 08:52:54 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:42625
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758218AbXF0Mwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 08:52:53 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] hw_random: add quality categories
Date: Wed, 27 Jun 2007 14:52:10 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200706241555.22957.mb@bu3sch.de> <200706261645.24360.mb@bu3sch.de> <20070627031800.GJ11115@waste.org>
In-Reply-To: <20070627031800.GJ11115@waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706271452.11036.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 June 2007 05:18:00 Matt Mackall wrote:
> On Tue, Jun 26, 2007 at 04:45:24PM +0200, Michael Buesch wrote:
> > On Tuesday 26 June 2007 16:32:37 Matt Mackall wrote:
> > > > No wait. You are missing the whole point of this
> > > > quality category.
> > > > The whole point of it is to prevent defaulting to a bad RNG, if
> > > > there's a bad and a good one in a machine.
> > > > Well, what's bad.
> > > > It's easy. HWRNGs like the one in bcm43xx are bad.
> > > > It's proprietary and nobody knows what it does (I guess
> > > > it gathers the entropy from the network or something
> > > > and hashes that in hardware).
> > > > So such a device would be QUAL_LOW.
> > > 
> > > If it's gathering its entropy from the network, it is not a QUAL_LOW
> > > RNG because it is not a hardware random number generator at all!
> > > 
> > > Such a device is QUAL_PSEUDO or QUAL_UNKNOWN. If it's known or
> > > suspected to be bogus, it should be so marked. 
> > 
> > No, it should not be marked pseudo. It _is_ a RNG in hardware.
> 
> Again, if it's not using an underlying physical process that's
> unpredictable, it does not deserve to be called a real HWRNG. It's no
> better than the software PRNG in the kernel at that point.
> 
> If you have a reasonable suspicion that this is the case with the BCM
> part, then you should so mark it.

Done so in the new patch.

> > No, that's not true. I explained the difference to you and it's even
> > explained in the kdoc help text. Re-read it, please.
> > HIGH is for seperate dedicated extension devices that you buy and
> > stick into your machine. So it would default to that, as you want
> > to use that by default (why would you otherwise stick it in).
> 
> I do not believe there exist devices that deserve to be classified as
> "HIGH".

You still didn't understand what I am trying to explain.
Please look at my new patch. The "DEDICATED" type is what QUAL_HIGH
meant.

Again: It is _just_ for selecting a default policy of which RNG
to enable by default. It is _not_ about quality. (And so the QUAL_XXX
defines were misnamed).

-- 
Greetings Michael.
