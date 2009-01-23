Return-Path: <linux-kernel-owner+w=401wt.eu-S1756834AbZAWPWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbZAWPWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 10:22:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbZAWPWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 10:22:47 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45476 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbZAWPWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 10:22:47 -0500
Date: Fri, 23 Jan 2009 16:22:36 +0100
From: Pavel Machek <pavel@suse.cz>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: HP accelerometer driver: testers wanted
Message-ID: <20090123152235.GA23668@elf.ucw.cz>
References: <20090122213139.GD2159@elf.ucw.cz> <200901222301.57681.elendil@planet.nl> <20090122221708.GA3430@elf.ucw.cz> <200901230011.31871.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901230011.31871.elendil@planet.nl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Minor issue in the patch: hpfall.c should not be executable:
> -rwxr-xr-x 1 fjp fjp  1759 2009-01-22 23:31 hpfall.c

Hmm, fixed in my local tree, but will have to think about how to make
it into patch.

> > Run hpfall, and see if LED lights and disk parks if you "drop" a
> > computer. (*)
> 
> $ sudo ./hpfall &
> 
> The LED lights up yellow, but I have problems telling if the disk gets 
> parked or not. One time I got a green led and seemingly a fair amount of 
> activity immediately after getting the yellow led.
> 
> After looking at hpfall.c, I checked /sys/block/sda/device/unload_heads 
> after a drop:
> $ cat /sys/block/sda/device/unload_heads
> 19616
> $ cat /sys/block/sda/device/unload_heads
> 0

Ok, so drop detection works for you; good. I could see disk activity
stopping during find / ...

> Wouldn't it be good to have locks/unlocks registered in the logs when
> /sys/block/sda/device/unload_heads changes (assuming the actual write will 
> get delayed until the head is unparked)?

That would fill the logs rather quickly, right?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
