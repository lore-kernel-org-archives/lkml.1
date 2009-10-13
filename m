Return-Path: <linux-kernel-owner+w=401wt.eu-S934086AbZJMTP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934086AbZJMTP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 15:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbZJMTP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 15:15:26 -0400
Received: from outbound-mail-319.bluehost.com ([67.222.54.251]:35757 "HELO
	outbound-mail-319.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751658AbZJMTPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 15:15:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Nh8cXcyzD98nEec9qN8hw73+oYv+KRCC2NWP0POKPOWil81b71IqyzbMDcM1nLTsSB9PtdqHyIcK5vgvK1QkWmkmxgjNakwoAK9coZVaGO5kHiMS6s3HIUNOcHHvTVHp;
Date: Tue, 13 Oct 2009 12:14:26 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Theodore Tso <tytso@mit.edu>
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org, Keith Packard <keithp@keithp.com>
Subject: Re: 2.6.32 regression (bisected): Video tearing/glitching with T400
 laptops
Message-ID: <20091013121426.35f409ff@jbarnes-g45>
In-Reply-To: <20091013190055.GI8175@mit.edu>
References: <E1Mtqnb-0002x7-TJ@closure.thunk.org>
	<20091008103620.5e5aae66@jbarnes-g45>
	<20091010204106.GA8251@mit.edu>
	<20091012095438.1e82b54f@jbarnes-g45>
	<20091012184651.GA4603@Pilar.aei.mpg.de>
	<20091012120510.16bd1194@jbarnes-g45>
	<20091013023146.GA8414@mit.edu>
	<20091013100135.2b3d914f@jbarnes-g45>
	<20091013190055.GI8175@mit.edu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009 15:00:55 -0400
Theodore Tso <tytso@mit.edu> wrote:

> Thanks, should I apply this on top of your previous patch, or on a
> completely virgin 2.6.32-rc3 tree?

Either way should be fine, since the previous patches don't appear to
be helping (they shouldn't hurt either).

> I don't know if this helps, but the amount of tearing seems to be
> roughly proportional to how many "white" pixels are on the screen.
> There isn't much tearing if I just have my (brown) Ubuntu 9.04 default
> background image.  There is a bit more tearing on the virtual desktop
> once I open an 80x52 black-on-white gnome-terminal window, so that 45%
> of my widescreen has white pixels due to the backgrouin of the
> gnome-terminal.
> 
> On the virtual desktop where my firefox browser is opened, the
> tearing/glitching is much more frequent.  And where the
> tearing/glitching is seems to be be roughly related to where the mouse
> cursor happens to be.  (Usually starting at the horizontol row of
> pixels where the mouse is going down towards the bottom of the screen;
> although sometimes if the mouse is very close to the bottom of the
> screen, there is some tearing at the top of the screen as well.)
> 
> Does this description help at all?  Would a video clip of the
> tearing/glitching be useful?

Thanks for the description, it matches what I've seen on Eric and Ian's
machines, though I can't reproduce it myself.

According to the chipset team that form of display corruption is likely
related to RAM self-refresh... Sounds like the display plane isn't
getting its memory requests serviced fast enough when in self-refresh
mode, which might mean we have to program the self-refresh watermarks
more aggressively on GM45.

-- 
Jesse Barnes, Intel Open Source Technology Center
