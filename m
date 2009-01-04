Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136AbZADIld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbZADIld (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 03:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbZADIlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 03:41:24 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:41423 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbZADIlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 03:41:23 -0500
Message-ID: <49607626.8010803@davidnewall.com>
Date: Sun, 04 Jan 2009 19:11:10 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Chris Adams <cmadams@hiwaay.net>
CC: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       linasvepstas@gmail.com, "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       Travis Crump <pretzalz@techhouse.org>,
       Goodgerster <goodgerster@gmail.com>
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years
 2008-2009
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com> <20090102210430.49649261@diego-desktop> <495E7849.4030706@shaw.ca> <495F0672.6020708@davidnewall.com> <20090103070022.GC1538533@hiwaay.net>
In-Reply-To: <20090103070022.GC1538533@hiwaay.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Adams wrote:
> The leap second isn't a simple thing like a time zone.  Zones account
> for an offset from UTC
Time zones are described that way, but I was wondering why not use
zoneinfo, which describes the local time after an arbitrary number of
seconds since the epoch.  The leap second is a textbook case for
updating zoneinfo.


> , but a leap second is an extra second inserted
> into (or possibly removed from) UTC itself.  There was actually a 61
> second minute on Dec. 31.


> The trouble comes in keeping the "seconds
> since the epoch" counter sane, meaning (seconds % 86400) == 0 at
> 00:00:00 UTC.

That sounds like an irrelevant quality, and as we've seen, striving for
it has caused difficulties. Worse, we've now got the situation where the
number of seconds between midnight starting December 31 and midnight
starting January 1 is incorrect.  The correct value is 86401, because
that's how many seconds there were.

> Since there were 86401 seconds Dec. 31, the kernel had to
> tick the last second twice to keep correct UTC time.

It didn't have to, but apparently, and regrettably, that's what was
done; leaving an even bigger problem.  How many seconds does the
computer claim were in 2008?  Probably not enough.
