Return-Path: <linux-kernel-owner+w=401wt.eu-S1755126Ab0ANVQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab0ANVQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 16:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834Ab0ANVQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 16:16:19 -0500
Received: from mail.elliptictech.com ([209.217.122.41]:38078 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753239Ab0ANVQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 16:16:19 -0500
Date: Thu, 14 Jan 2010 16:16:10 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Peter Clifton <pcjc2@cam.ac.uk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, airlied@linux.ie,
       intel-gfx@lists.freedesktop.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: disable LVDS downclock by default
Message-ID: <20100114211610.GA2030@emergent.ellipticsemi.com>
Mail-Followup-To: Peter Clifton <pcjc2@cam.ac.uk>,
	Jesse Barnes <jbarnes@virtuousgeek.org>, airlied@linux.ie,
	intel-gfx@lists.freedesktop.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <84144f021001131303u56fa5470ua1c27dfef9f3de81@mail.gmail.com>
 <20100113133357.67f9df6d@jbarnes-piketon>
 <4B4E403C.1050509@cs.helsinki.fi>
 <20100113165530.2a7e7645@jbarnes-piketon>
 <4B4F6D5F.10008@cs.helsinki.fi>
 <20100114193118.GA1203@emergent.ellipticsemi.com>
 <84144f021001141218pa3cd71co76165532618145a8@mail.gmail.com>
 <20100114202803.GA1749@emergent.ellipticsemi.com>
 <20100114124802.025bbcae@jbarnes-piketon>
 <1263502711.16937.5.camel@pcjc2lap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263502711.16937.5.camel@pcjc2lap>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20:58 Thu 14 Jan     , Peter Clifton wrote:
> On Thu, 2010-01-14 at 12:48 -0800, Jesse Barnes wrote:
> > Many platform support this feature, and it can provide significant
> > power savings when the reduced refresh rate is low.  However, on some
> > platforms a secondary (reduced) timing is provided but not actually
> > supported by the hardware.  This results in undesirable flicker at
> > runtime.
> > 
> > So disable the feature by default, but allow users to opt-in to the
> > reduced clock behavior with a new module parameter, lvds_downclock,
> > that can be set to 1 to enable the feature.
> 
> Would it not be a better idea to turn this feature on by default, then
> use quirks to disable it on the afflicted borken machines?

If there is a high degree of confidence that correct quirks are in place
for all "afflicted borken machines", then this is probably OK.

The difference between 2.6.32 and 2.6.33-rc1 on the T500 is phenominal:
the LVDS display is so erratic in the latter as to be almost completely
useless.  There is a patch on fdo bugzilla which makes the display less
broken, but there is still distracting flicker.

> Requiring special module parameters to enable the feature, almost
> guarantees that no normal end-users will end up benefiting from the
> feature. Many of whom will have bought machines which don't have screwey
> BIOS implementations.

On the other hand, it completely guarantees that no normal end-users
will end up with useless displays as a result of the feature.  Many of
whom have bough machines which have screwey BIOS implementations (or
whatever the problem actually is).

> I think (on a general note) that vendors supplying defective BIOSen or
> config should be "named and shamed" in quirk tables - so eventually they
> will get something done about the problems for future models.

Is it really a defective BIOS?  I don't have my laptop handy right now,
but the lower refresh mode is reported in the EDID and can be set
successfully (no idea if the change actually does anything).  However,
there is a visible artifact whenever a transition occurs.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
