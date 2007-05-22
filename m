Return-Path: <linux-kernel-owner+w=401wt.eu-S1760792AbXEVXgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760792AbXEVXgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 19:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757336AbXEVXge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 19:36:34 -0400
Received: from outbound-mail-44.bluehost.com ([69.89.18.13]:51558 "HELO
	outbound-mail-44.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757458AbXEVXgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 19:36:33 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Date: Tue, 22 May 2007 16:36:20 -0700
User-Agent: KMail/1.9.6
Cc: dri-devel@lists.sourceforge.net, Jesse Barnes <jesse.barnes@intel.com>,
       James Simmons <jsimmons@pentafluge.infradead.org>,
       Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
References: <200705171423.46748.jesse.barnes@intel.com> <200705220839.04773.jbarnes@virtuousgeek.org> <1179876398.32247.885.camel@localhost.localdomain>
In-Reply-To: <1179876398.32247.885.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705221636.20848.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 22, 2007, Benjamin Herrenschmidt wrote:
> On Tue, 2007-05-22 at 08:39 -0700, Jesse Barnes wrote:
> > The current code does its best to figure out what modes are available
> > and tries to pick a good one for each display.  It sounds like you're
> > mainly concerned with the actual mode picking, not the mode and output
> > detection and enumeration?  If so, that's a pretty easy change to
> > make.  But if you're also worried about the kernel building mode
> > lists, then we'll have bigger changes to make...
>
> I'm worried that the EDID we get from the monitor is bogus and needs to
> be overriden.
>
> Now, if the kernel builds a mode list, that's find if we have a call to
> "feed" it with a replacement one later on from userland.
>
> In addition, there are all those monitors that cannot be probed (no
> DDC/EDID) and for which only userland can reasonably provide a mode or a
> mode list.

Yeah, we already have a call to add modes to the kernel's list, so we 
should be covered.

> So it's a bit of both :-) Building an "initial" mode list from the EDID
> might be fair enough if we can replace it soon enough, but we still need
> to be very conservative about whatever boot mode we choose.

Right.

> > I'm not really sure how much of a problem broken EDIDs will be.  The X
> > server only has a few quirks for broken EDIDs now, nothing major
> > afaict, and apparently the FB layer already has some code for handling
> > EDID quirks, so I don't think that'll be our biggest problem.  So far,
> > it looks like handling laptop panels is a bit trickier (at least for
> > Intel chips)...
>
> Well, I've seen my share of broken EDID.. Last time I looked at Darwin,
> I think I saw Apple maintaining a fairly huge database of EDID
> replacements in userland...

Interesting... I wonder how the distro monitor databases compare.

Jesse


