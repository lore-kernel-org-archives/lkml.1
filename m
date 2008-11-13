Return-Path: <linux-kernel-owner+w=401wt.eu-S1752171AbYKMPhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbYKMPhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 10:37:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbYKMPha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 10:37:30 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53233 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751052AbYKMPha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 10:37:30 -0500
Date: Thu, 13 Nov 2008 16:37:14 +0100
From: Pavel Machek <pavel@suse.cz>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jeremy Katz <katzj@redhat.com>, Andres Salomon <dilinger@queued.net>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jordan Crouse <jordan.crouse@amd.com>, linux-kernel@vger.kernel.org,
       dsaxena@laptop.org
Subject: Re: [PATCH] x86 - Make CONFIG_OLPC dependent on CONFIG_MGEODE_LX
Message-ID: <20081113153714.GA1520@ucw.cz>
References: <20081111125402.GB14989@elte.hu> <s5hzlk6pea6.wl%tiwai@suse.de> <20081111135306.GA32709@elte.hu> <s5hwsfapdoj.wl%tiwai@suse.de> <20081111140406.GA3244@elte.hu> <20081109201710.4c490f04@debxo> <1226498050.12791.45.camel@aglarond.local> <s5hbpwlj9w1.wl%tiwai@suse.de> <1226547898.13077.83.camel@aglarond.local> <s5h63msru7z.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h63msru7z.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > > > but what we really need to
> > > > > do is to make geode_gpio* defined even when we're not specifically
> > > > > building with MGEODE_LX.  I'm not sure how best to do that, but the
> > > > > answer probably includes using the generic x86 gpio api.
> > > > 
> > > > This probably needs to be done as a precondition for getting the alsa
> > > > changes merged or the alsa changes need to have the bits which depend on
> > > > geode_gpio ripped out until it can be done.
> > > 
> > > Then let's stop inclusion of asm/geode.h from asm/olpc.h at first.
> > > Any driver codes including asm/geode.h can be broken potentially
> > > without a proper dependency.
> > 
> > Yes, but having a driver dependent on building for a specific x86
> > variant is quite wrong. 
> 
> Not so.  Many drivers are very hardware-specific, and they are (must
> be) based on certain architectures and platforms.  Look at a bunch of
> drivers based on ARM-variants, for example.

No.

It should be possible to compile kernel for i386 and have it run on
OLPC. This breaks it.

CPU type is optimalization option, only.

> IMO, the basic problem is rather that the platform and the CPU
> selection is mixed up.  The geode GPIO stuff shouldn't belong to CPU
> selection.

ACK... and suggested patch makes it worse.

There should be option 'support OLPC' somewhere, and that should
enable the gpio bits. Alsa driver should depend on that one.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
