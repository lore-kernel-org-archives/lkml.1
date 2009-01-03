Return-Path: <linux-kernel-owner+w=401wt.eu-S1758848AbZACHAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848AbZACHAo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 02:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbZACHAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 02:00:36 -0500
Received: from bee.hiwaay.net ([216.180.54.11]:19450 "EHLO bee.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbZACHAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 02:00:35 -0500
Date: Sat, 3 Jan 2009 01:00:22 -0600
From: Chris Adams <cmadams@hiwaay.net>
To: David Newall <davidn@davidnewall.com>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       linasvepstas@gmail.com, "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       Travis Crump <pretzalz@techhouse.org>,
       Goodgerster <goodgerster@gmail.com>
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
Message-ID: <20090103070022.GC1538533@hiwaay.net>
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com> <20090102210430.49649261@diego-desktop> <495E7849.4030706@shaw.ca> <495F0672.6020708@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495F0672.6020708@davidnewall.com>
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once upon a time, David Newall <davidn@davidnewall.com> said:
> I don't understand this idea, nor the patch for the problem.  I don't
> see why adding a leap second would impact the kernel in any way. 
> Shouldn't this be a simple zoneinfo change, whereby the last two seconds
> of the year (in each timezone) both map to 31dec2008 23:59:59?  That's
> the way the change has worked in the real world.  Why would ntp or the
> kernel be involved?

The leap second isn't a simple thing like a time zone.  Zones account
for an offset from UTC, but a leap second is an extra second inserted
into (or possibly removed from) UTC itself.  There was actually a 61
second minute on Dec. 31.  The trouble comes in keeping the "seconds
since the epoch" counter sane, meaning (seconds % 86400) == 0 at
00:00:00 UTC.  Since there were 86401 seconds Dec. 31, the kernel had to
tick the last second twice to keep correct UTC time.

NTP is used to distribute and synchronize time information, including
leap second info.

See Wikipedia and Google for more information.
-- 
Chris Adams <cmadams@hiwaay.net>
Systems and Network Administrator - HiWAAY Internet Services
I don't speak for anybody but myself - that's enough trouble.
