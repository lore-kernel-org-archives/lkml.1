Return-Path: <linux-kernel-owner+w=401wt.eu-S1760902AbZAWJOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760902AbZAWJOD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 04:14:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbZAWJNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 04:13:42 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41185 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760695AbZAWJNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 04:13:41 -0500
Date: Fri, 23 Jan 2009 10:13:37 +0100
From: Pavel Machek <pavel@suse.cz>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: HP accelerometer driver: testers wanted
Message-ID: <20090123091337.GA4296@elf.ucw.cz>
References: <20090122213139.GD2159@elf.ucw.cz> <20090122221708.GA3430@elf.ucw.cz> <200901230011.31871.elendil@planet.nl> <200901230959.25491.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901230959.25491.elendil@planet.nl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-01-23 09:59:25, Frans Pop wrote:
> On Friday 23 January 2009, Frans Pop wrote:
> > The LED lights up yellow, but I have problems telling if the disk gets
> > parked or not. One time I got a green led and seemingly a fair amount
> > of activity immediately after getting the yellow led.
> >
> > After looking at hpfall.c, I checked /sys/block/sda/device/unload_heads
> > after a drop:
> > $ cat /sys/block/sda/device/unload_heads
> > 19616
> > $ cat /sys/block/sda/device/unload_heads
> > 0
> >
> > The last was at most 2 seconds after the first, certainly not 20...
> 
> I've just looked at hpcall.c a bit closer and I guess that's because of 
> the alarm(2) call? I must admit having some problems reading that
> code.

Yes, it works as designed. Change if (1 || into if (0) and you'll get
20 second timeouts.

(It initially asks for 20 seconds to give itself time for those other
calculations.)
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
