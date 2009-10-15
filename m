Return-Path: <linux-kernel-owner+w=401wt.eu-S1762820AbZJOPb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762820AbZJOPb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 11:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762796AbZJOPb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 11:31:27 -0400
Received: from outbound-mail-320.bluehost.com ([67.222.54.252]:55084 "HELO
	outbound-mail-320.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762231AbZJOPb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 11:31:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=bw3Dz96Ku2Yk1YhSXifV8GyyzjRoaJrEJps0uSHTR66MvNhSvDVxTW1xDC61zwH0tehjtrqzTIGRQJ5EyqLEvTH3clLra1++SxTXFvxbBzAaL7RI4Se1bXinfamX6NG8;
Date: Thu, 15 Oct 2009 08:30:23 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Theodore Tso <tytso@mit.edu>
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org, Keith Packard <keithp@keithp.com>,
       Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: 2.6.32 regression (bisected): Video tearing/glitching with T400
 laptops
Message-ID: <20091015083023.2f389296@jbarnes-g45>
In-Reply-To: <20091015022645.GA8286@mit.edu>
References: <20091008103620.5e5aae66@jbarnes-g45>
	<20091010204106.GA8251@mit.edu>
	<20091012095438.1e82b54f@jbarnes-g45>
	<20091012184651.GA4603@Pilar.aei.mpg.de>
	<20091012120510.16bd1194@jbarnes-g45>
	<20091013023146.GA8414@mit.edu>
	<20091013100135.2b3d914f@jbarnes-g45>
	<20091013190055.GI8175@mit.edu>
	<20091013121426.35f409ff@jbarnes-g45>
	<20091014142252.009d03a5@jbarnes-g45>
	<20091015022645.GA8286@mit.edu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Oct 2009 22:26:45 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Wed, Oct 14, 2009 at 02:22:52PM -0700, Jesse Barnes wrote:
> > On Tue, 13 Oct 2009 12:14:26 -0700
> > Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > > According to the chipset team that form of display corruption is
> > > likely related to RAM self-refresh... Sounds like the display
> > > plane isn't getting its memory requests serviced fast enough when
> > > in self-refresh mode, which might mean we have to program the
> > > self-refresh watermarks more aggressively on GM45.
> > 
> > Ok, like any good bug there was more than one thing wrong:
> >   - we weren't setting up a fence for the object before enabling
> > FBC. Chris caught this and posted a patch to
> >     intel-gfx@lists.freedesktop.org titled "drm/i915: Install a
> > fence register for fbc on g4x" (attached for convenience)
> >   - turns out we *do* need to set watermarks on G4x, despite some hw
> >     documentation indicating otherwise, patch for that attached
> > 
> > Hopefully with these two you'll have a solid display and some power
> > saving!
> 
> With these two patches (and none of your prior ones) applied to
> 2.6.32-rc3, things are definitely better.  I'm still seeing a few
> glitches (one as mutt was loading my Maildir inbox) and one as I was
> typing this message in emacs, but it's at best one minor every 5-10
> minutes.  It's rare enough to be at most a wee bit distracting (*lots*
> better than before), and I can see the power savings.
> 
> If I need to live with a display glitch every 5-10 minutes or so to
> get better power savings, I'll take it....

Oh I think we can do better than that.  The hardcoded values I put in
for the watermarks are almost certainly wrong.  I should be able to
reproduce what you're seeing (anything that takes a lot of memory
bandwidth will probably cause flicker) and adjust the watermarks to the
correct values to avoid that.  I'll try to find time in Japan to do
that...

-- 
Jesse Barnes, Intel Open Source Technology Center
