Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbZAEOdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbZAEOdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 09:33:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbZAEOdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:33:43 -0500
Received: from vps1.tull.net ([66.180.172.116]:40784 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754046AbZAEOdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:33:42 -0500
Date: Tue, 6 Jan 2009 01:33:35 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: Linas Vepstas <linasvepstas@gmail.com>
Cc: David Newall <davidn@davidnewall.com>, david@lang.hm,
       Kyle Moffett <kyle@moffetthome.net>,
       Ben Goodger <goodgerster@gmail.com>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org, "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       Travis Crump <pretzalz@techhouse.org>, burdell@iruntheinter.net
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years	2008-2009
Message-ID: <20090105143335.GC18055@mail.local.tull.net>
References: <495F0672.6020708@davidnewall.com> <8752a8760901022237r75d408b3i74c703c8ac2d4597@mail.gmail.com> <496076A9.7030907@davidnewall.com> <f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com> <4960897D.5030603@davidnewall.com> <alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm> <4961432A.80509@davidnewall.com> <alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm> <49614835.7000505@davidnewall.com> <3ae3aa420901042148o1c96985dube8e03085c997a07@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ae3aa420901042148o1c96985dube8e03085c997a07@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2009 at 11:48:31PM -0600, Linas Vepstas wrote:
> There *was* talk of eliminating them forever (so as to
> avoid this kind of bug, which affects banks, satellites,
> telecom equipment, etc.) but I guess they didn't do it.

I can sympathise with the opinion that linux should be able to accurately
distinguish xx:59:60 when a leap second is added (or the missing :59 when
one is subtracted) but not at the expense of making a day which is not
86400 seconds long.

To fix the problem would require accurately modeling international
timekeeping standards such as TAI and use of different syscalls to
return time in TAI and UTC-with-leap-seconds represented. It
wouldn't be good to change the semantics of time().

* http://en.wikipedia.org/wiki/International_Atomic_Time
* http://en.wikipedia.org/wiki/Leap_second

Arguably the kernel's responsibility should be to keep track of the
most fundamental representation of time possible for a machine (that's
probably TAI) and it is a userspace responsibility to map from that
value to other time standards including UTC, using control files
which are updated as leap seconds are declared. Just so long as the
existing behaviour of time() which doesn't recognise leap seconds
is preserved.

Nick.
