Return-Path: <linux-kernel-owner+w=401wt.eu-S1762277AbXEVX2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762277AbXEVX2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 19:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761993AbXEVX2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 19:28:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:37092 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761918AbXEVX2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 19:28:10 -0400
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: dri-devel@lists.sourceforge.net, Jesse Barnes <jesse.barnes@intel.com>,
       James Simmons <jsimmons@pentafluge.infradead.org>,
       Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <200705220839.04773.jbarnes@virtuousgeek.org>
References: <200705171423.46748.jesse.barnes@intel.com>
	 <1179792587.32247.769.camel@localhost.localdomain>
	 <200705220839.04773.jbarnes@virtuousgeek.org>
Content-Type: text/plain
Date: Wed, 23 May 2007 09:26:37 +1000
Message-Id: <1179876398.32247.885.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-22 at 08:39 -0700, Jesse Barnes wrote:
> 
> The current code does its best to figure out what modes are available and 
> tries to pick a good one for each display.  It sounds like you're mainly 
> concerned with the actual mode picking, not the mode and output detection 
> and enumeration?  If so, that's a pretty easy change to make.  But if 
> you're also worried about the kernel building mode lists, then we'll have 
> bigger changes to make...

I'm worried that the EDID we get from the monitor is bogus and needs to
be overriden.

Now, if the kernel builds a mode list, that's find if we have a call to
"feed" it with a replacement one later on from userland.

In addition, there are all those monitors that cannot be probed (no
DDC/EDID) and for which only userland can reasonably provide a mode or a
mode list.

So it's a bit of both :-) Building an "initial" mode list from the EDID
might be fair enough if we can replace it soon enough, but we still need
to be very conservative about whatever boot mode we choose.

> I'm not really sure how much of a problem broken EDIDs will be.  The X 
> server only has a few quirks for broken EDIDs now, nothing major afaict, 
> and apparently the FB layer already has some code for handling EDID 
> quirks, so I don't think that'll be our biggest problem.  So far, it looks 
> like handling laptop panels is a bit trickier (at least for Intel 
> chips)...

Well, I've seen my share of broken EDID.. Last time I looked at Darwin,
I think I saw Apple maintaining a fairly huge database of EDID replacements
in userland...

Ben.

