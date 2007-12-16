Return-Path: <linux-kernel-owner+w=401wt.eu-S1763339AbXLPDYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763339AbXLPDYT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 22:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756148AbXLPDYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 22:24:06 -0500
Received: from cg-p07-fb.rzone.de ([81.169.146.215]:19498 "EHLO
	cg-p07-fb.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002AbXLPDYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 22:24:05 -0500
X-RZG-CLASS-ID: mo07
X-RZG-AUTH: lEAzdeI4dSN9VuBdaqrKvzFA3p9QfMrmrF4hYoiThG+OHraeCXS1
From: Stefan Lippers-Hollmann <s.L-H@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Date: Sun, 16 Dec 2007 04:20:52 +0100
User-Agent: KMail/1.9.7
Cc: "John W. Linville" <linville@tuxdriver.com>, Michael Buesch <mb@bu3sch.de>,
       Daniel Walker <dwalker@mvista.com>, akpm@linux-foundation.org,
       stefano.brivio@polimi.it, Ray Lee <ray-lk@madrabbit.org>,
       matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org,
       mbuesch@freenet.de, linux@bohmer.net, kjwinchester@gmail.com,
       jonathan@jonmasters.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       bcm43xx-dev@lists.berlios.de
References: <20071213003028.676998182@mvista.com> <20071215214300.GC3096@tuxdriver.com> <200712160026.20730.rjw@sisk.pl>
In-Reply-To: <200712160026.20730.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712160420.58500.s.L-H@gmx.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sonntag, 16. Dezember 2007, Rafael J. Wysocki wrote:
> On Saturday, 15 of December 2007, John W. Linville wrote:
> > On Sat, Dec 15, 2007 at 02:25:50AM +0100, Rafael J. Wysocki wrote:
> > > On Friday, 14 of December 2007, Michael Buesch wrote:
> > 
> > > > Either distributions have to install it automatically or people simply have
> > > > to read one or two lines of documentation.  That's just what I wanted to say.
> > > 
> > > It's not that simple.  For example, regression testing will be a major PITA
> > > if one needs to switch back and forth from the new driver to the old one in the
> > > process.
> > 
> > Not really true -- a single system can easily have firmware installed
> > for b43, b43legacy, and bcm43xx at the same time and switch back and
> > forth between them.
> > 
> > Given a functioning udev configuration, the persistent naming even
> > works so that your device stays as 'eth1' when switching to and
> > fro bcm43xx.
> 
> Well, this last bit doesn't work on my openSUSE 10.3.  Honest, guv. ;-)

The persistent interface naming rules of udev, at least up to 0.114-2 
(current debian unstable), seem to be easily confused if the driver names 
change for the same MAC address. This issue seems not to be b43 specific, 
it happens with zd1211rw --> zd1211rw_mac80211 (this one won't show up in 
mainline kernels), prism54 --> p54pci/ p54usb, out-of-tree RaLink legacy/ 
serialmonkey (which ignore interface renames through udev completely) --> 
rt2x00 just as well and I assume that it might also affect sk98lin --> 
skge/ sky and the upcomming e1000 --> e1000e transitions and similar 
situations.

> > I really think everyone is overstating the problem.
> 
> You might be right.

It is of course confusing to the user and might affect remote updates, but 
it's also easily fixed by removing the generated MAC address mappings and 
letting udev generate new ones (+ post processing, if needed) during the 
next boot.

> Greetings,
> Rafael

Regards
	Stefan Lippers-Hollmann
