Return-Path: <linux-kernel-owner+w=401wt.eu-S1752517AbXA2RkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbXA2RkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 12:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbXA2RkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 12:40:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:58057 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbXA2RkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 12:40:20 -0500
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@osdl.org>
Subject: Re: [PATCH] Fix /sys/device/.../power/state regression
Date: Mon, 29 Jan 2007 09:36:45 -0800
Organization: OSDL
Message-ID: <20070129093645.3c2d30df@freekitty>
References: <20061219185223.GA13256@srcf.ucam.org>
	<200701261642.56896.david-b@pacbell.net>
	<20070127011954.GA13534@srcf.ucam.org>
	<200701261902.38247.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Trace: build.pdx.osdl.net 1170092344 2043 10.8.0.54 (29 Jan 2007 17:39:04 GMT)
X-Complaints-To: abuse@osdl.org
NNTP-Posting-Date: Mon, 29 Jan 2007 17:39:04 +0000 (UTC)
X-Newsreader: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007 19:02:37 -0800
David Brownell <david-b@pacbell.net> wrote:

> On Friday 26 January 2007 5:19 pm, Matthew Garrett wrote:
> > On Fri, Jan 26, 2007 at 04:42:56PM -0800, David Brownell wrote:
> > > On Friday 26 January 2007 3:15 pm, Matthew Garrett wrote:
> > > > It's certainly the case that fixing those drivers would result in a 
> > > > better long-term situation - however, nobody currently seems to have any 
> > > > interest in doing so...
> > > 
> > > And the way these things work, unfortunately, is that merging your patch
> > > would ensure nobody ever gets such interest.  Removing that "state" file
> > > (and its bogus infrastructure) has already taken a few years too long.
> > 
> > I'd argue that the onus is on those who wish to remove the interface to 
> > ensure that equivalent functionality exists first.
> 
> Are you now arguing that "rmmod $DRIVER" doesn't suffice for what you
> were wanting to do?  If so, why?  What's the delta in power usage?

For the case that started the discussion (wireless network devices).
The expected behavior is that the device remains in a low power state
until it enabled (set to up). If really smart a wired network device
can also stay in low power state until carrier is detected. There are
also other network device states (dormant, lower layer down), not currently
in use that could also be useful.

The point is that using the /sys/device/.../power/state file
is not the right way to handle network devices. Power usage should
correlate to device status, not be controlled differently.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
