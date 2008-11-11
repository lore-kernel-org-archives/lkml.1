Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbYKKEPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbYKKEPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 23:15:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbYKKEPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 23:15:08 -0500
Received: from ipx-119-252-190-80.ipxserver.de ([80.190.252.119]:51505 "EHLO
	ipx10616.ipxserver.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750787AbYKKEPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 23:15:07 -0500
X-Greylist: delayed 332 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Nov 2008 23:15:06 EST
Date: Tue, 11 Nov 2008 14:13:42 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: Arjan Opmeer <arjan@opmeer.net>
Cc: Henrik Rydberg <rydberg@euromail.se>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Add a detailed multi-touch finger data report
	protocol
Message-ID: <20081111041341.GB6776@dingo.redhat.com>
References: <49142351.9080805@euromail.se> <20081108005125.GA24783@adopmeer.homeip.net> <49156D54.8060109@euromail.se> <20081108112901.GA12987@adopmeer.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081108112901.GA12987@adopmeer.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 08, 2008 at 12:29:02PM +0100, Arjan Opmeer wrote:
> > It is designed to bring advanced gestures to the linux desktop.
> 
> Certainly. Have you already thought about the rest of the path from driver
> to application, ie kernel driver -> X.org driver -> X events -> toolkit
> events -> application?
> 
> For instance does the X.org driver interpret the data and emit a zoom or
> rotate event based on the finger position and movement? As far as I know
> those event do not exist and would have to be added to X.org as well as the
> toolkits like GTK+ and Qt. It could be a long implementation process... :(

IMHO the server or driver shouldn't do anything with the event but pass it on
to the client. What the events then mean semantically depends on the client
(or the toolkit). This replicates pretty much what we do with mouse events and
although it puts the burden on the client side to do anything useful, it makes
it easier to develop, debug and also to do non-standard interpretation of
gestures.

The X server's job is basically just to pick the right client to send the
events to, and of course augment the events with X specific data (such as the
window).

Cheers,
  Peter
