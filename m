Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbZG2HbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbZG2HbD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 03:31:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbZG2HbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 03:31:03 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:49760 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbZG2HbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 03:31:01 -0400
Date: Wed, 29 Jul 2009 16:31:00 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ian Molton <ian@mnementh.co.uk>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Magnus Damm <damm@opensource.se>
Subject: Re: MMC: Make the configuration memory resource optional
Message-ID: <20090729073059.GA31506@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Ian Molton <ian@mnementh.co.uk>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
	Magnus Damm <damm@opensource.se>
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange> <4A6F033B.7030302@mnementh.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A6F033B.7030302@mnementh.co.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 02:55:07PM +0100, Ian Molton wrote:
> Guennadi Liakhovetski wrote:
> >Add support for tmio_mmc hardware configurations, that lack the cnf io 
> >area, like SuperH SoCs. With this patch such hardware can pass a single 
> >ctl io area with the platform data.
> 
> NAK
> 
> I dont like this approach - although it involves minimal changes to the 
> driver, it will leave people puzzling over why their accesses to the cnf 
> registers do nothing when debugging.
> 
Are you serious? The cnf window does _not exist_ in these cases. How much
more simply do you want it spelled out for you? And there are plenty of
cases where drivers take a variable number of resources for these sorts
of things already in tree. The only one confused here seems to be you.

> The cnf area is basically clock and power control for devices that have 
> it. If I had known of the existence of other tmio devices that didnt do 
> it that way when I wrote the driver, it would never have been put in 
> there directly.
> 
.. devices that have it, yes. It however is entirely an optional area,
and there are those that do not. Your lack of foresight in this area is
entirely unrelated to the issue at hand. These devices exist, you don't
want to deal with them, so we need to figure out how to move on from that
point.

> The *right* way to do this is to use the clk API for clocks and provide 
> a small API for power control that the driver will use, if present.
> 
The right way is to pretend that the area exists when it really doesn't?
As far as tying in the clocks, yes, that can use a virtual name that we
just map out on the CPU side. But as far as the power control, this area
again does not exist, and we will not be doing anything that pretends
otherwise. The driver has to be aware of the fact that this is an
optional area, and deal with that, rather than the other way around.

> If people want to change the situation in TMIO re: clocks, as I have 
> said before, they should start a discussion on how to adapt the clk API. 
>  so that more than just the CPU can use it. This will make everyone 
> happy all in one go.
> 
This is an orthogonal change, and is certainly something that could be
looked at at a later point in time. Presently however this does not
exist, and making that a requirement for something you didn't think of is
quite frankly absurd. The changes as they are are non-invasive, and you
have had ample time to construct technical reasons for why you are
opposed to them.

> I will happily take a patch abstracting power control from tmio-mmc, 
> however.
> 
Which is one of the things that this patch works towards. Quite frankly I
have a hard time understanding what your objections to any of this are.
You didn't consider the fact that these were optional components, and you
reject anything that works in that direction. If you don't want to
support those sorts of devices, that's your problem, and it's no reason
to keep the kernel back. 6 months to review 100 lines, seriously?

We will not now nor at any point maintain a local patchset for devices
that are in the wild for which upstream support mostly exists. The kernel
needs to deal with them, rather than just dealing with the class of
devices it supported when the driver was first merged. Any suggestions
that maintaining local patches is more useful than trying to work with
upstream only reflects on the maintainer's unwillingness to work with
others.

In summary, unless you have some real technical objections, I'll be
merging these patches through my tree in the next merge window. You are
free to NAK away all day long at that point.
