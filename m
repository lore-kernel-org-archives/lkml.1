Return-Path: <linux-kernel-owner+w=401wt.eu-S932985AbZJOCus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985AbZJOCus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 22:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758804AbZJOCus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 22:50:48 -0400
Received: from thunk.org ([69.25.196.29]:51700 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615AbZJOCur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 22:50:47 -0400
Date: Wed, 14 Oct 2009 22:26:45 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org, Keith Packard <keithp@keithp.com>,
       Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: 2.6.32 regression (bisected): Video tearing/glitching with
	T400 laptops
Message-ID: <20091015022645.GA8286@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	"Carlos R. Mafra" <crmafra2@gmail.com>,
	Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org,
	Keith Packard <keithp@keithp.com>,
	Chris Wilson <chris@chris-wilson.co.uk>
References: <20091008103620.5e5aae66@jbarnes-g45> <20091010204106.GA8251@mit.edu> <20091012095438.1e82b54f@jbarnes-g45> <20091012184651.GA4603@Pilar.aei.mpg.de> <20091012120510.16bd1194@jbarnes-g45> <20091013023146.GA8414@mit.edu> <20091013100135.2b3d914f@jbarnes-g45> <20091013190055.GI8175@mit.edu> <20091013121426.35f409ff@jbarnes-g45> <20091014142252.009d03a5@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014142252.009d03a5@jbarnes-g45>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 02:22:52PM -0700, Jesse Barnes wrote:
> On Tue, 13 Oct 2009 12:14:26 -0700
> Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > According to the chipset team that form of display corruption is
> > likely related to RAM self-refresh... Sounds like the display plane
> > isn't getting its memory requests serviced fast enough when in
> > self-refresh mode, which might mean we have to program the
> > self-refresh watermarks more aggressively on GM45.
> 
> Ok, like any good bug there was more than one thing wrong:
>   - we weren't setting up a fence for the object before enabling FBC.
>     Chris caught this and posted a patch to
>     intel-gfx@lists.freedesktop.org titled "drm/i915: Install a fence
>     register for fbc on g4x" (attached for convenience)
>   - turns out we *do* need to set watermarks on G4x, despite some hw
>     documentation indicating otherwise, patch for that attached
> 
> Hopefully with these two you'll have a solid display and some power
> saving!

With these two patches (and none of your prior ones) applied to
2.6.32-rc3, things are definitely better.  I'm still seeing a few
glitches (one as mutt was loading my Maildir inbox) and one as I was
typing this message in emacs, but it's at best one minor every 5-10
minutes.  It's rare enough to be at most a wee bit distracting (*lots*
better than before), and I can see the power savings.

If I need to live with a display glitch every 5-10 minutes or so to
get better power savings, I'll take it....

						- Ted
