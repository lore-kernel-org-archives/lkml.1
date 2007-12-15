Return-Path: <linux-kernel-owner+w=401wt.eu-S1759680AbXLOLA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759680AbXLOLA3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 06:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbXLOLAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 06:00:17 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:38430 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbXLOLAO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 06:00:14 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Date: Sat, 15 Dec 2007 11:57:43 +0100
User-Agent: KMail/1.9.6
Cc: bcm43xx-dev@lists.berlios.de,
       Simon Holm =?utf-8?q?Th=C3=B8gersen?= <odie@cs.aau.dk>,
       Daniel Walker <dwalker@mvista.com>, akpm@linux-foundation.org,
       Ray Lee <ray-lk@madrabbit.org>, matthias.kaehlcke@gmail.com,
       linux-kernel@vger.kernel.org, linux@bohmer.net, kjwinchester@gmail.com,
       jonathan@jonmasters.org, Ingo Molnar <mingo@elte.hu>
References: <20071213003028.676998182@mvista.com> <200712141404.24275.mb@bu3sch.de> <200712150151.49025.rjw@sisk.pl>
In-Reply-To: <200712150151.49025.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712151157.44278.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 December 2007 01:51:47 Rafael J. Wysocki wrote:
> On Friday, 14 of December 2007, Michael Buesch wrote:
> > On Friday 14 December 2007 13:59:54 Simon Holm Thøgersen wrote:
> > > > This user did get the following messages in dmesg:
> > > > 
> > > > b43err(dev->wl, "Firmware file \"%s\" not found "
> > > >        "or load failed.\n", path);
> > > 
> > > So the question seems to be why b43 needs version 4, when b43legacy and
> > > bcm43x uses version 3?
> > 
> > That's really a question, right?
> > 
> > Well. linux-2.4 doesn't work with the linux-2.6 modutils.
> > Windows Vista doesn't work with Windows 98 device drivers.
> > That leads to this assumption:
> > b43 doesn't work with version 3 firmware but needs version 4.
> > 
> > Newer drivers supporting newer hardware need newer firmware.
> 
> Actually, can you explain why, from the technical point of view, the version 4
> firware is better than version 3, please?

version 4 is the new firmware released by broadcom. They obviously won't
support and write any version 3 firmware anymore. So we are forced to
switch to version 4 firmware to support the newest hardware (like N-PHY
in the future). It's really as simple as that.
The difference between v3 and v4 is basically the driver API. It changed
a lot and it is nontrivial to support both v3 and v4 in one driver.
So we decided to stay with v3 for legacy devices and take v4 for any newer
devices. We have to live with that crap until someone comes up
with an opensource firmware. :)

-- 
Greetings Michael.
