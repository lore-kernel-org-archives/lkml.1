Return-Path: <linux-kernel-owner+w=401wt.eu-S1758296AbZADRUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296AbZADRUU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 12:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbZADRUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 12:20:07 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:1064 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbZADRUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 12:20:05 -0500
Message-ID: <f73f7ab80901040920h20c405farcef8ce708ed73216@mail.gmail.com>
Date: Sun, 4 Jan 2009 12:20:03 -0500
From: "Kyle Moffett" <kyle@moffetthome.net>
To: "David Newall" <davidn@davidnewall.com>
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
Cc: "Ben Goodger" <goodgerster@gmail.com>, "Robert Hancock" <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org, linasvepstas@gmail.com,
       "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       "Travis Crump" <pretzalz@techhouse.org>, burdell@iruntheinter.net
In-Reply-To: <4960897D.5030603@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>
	 <20090102210430.49649261@diego-desktop> <495E7849.4030706@shaw.ca>
	 <495F0672.6020708@davidnewall.com>
	 <8752a8760901022237r75d408b3i74c703c8ac2d4597@mail.gmail.com>
	 <496076A9.7030907@davidnewall.com>
	 <f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com>
	 <4960897D.5030603@davidnewall.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 4, 2009 at 5:03 AM, David Newall <davidn@davidnewall.com> wrote:
> You're confusing the system of keeping time with those characteristics
> of the real-world which it represents.  They are, in fact, two different
> things, hence we regularly adjust the system.  Now in the case of UNIX
> and derivatives, the system records the number of seconds since an
> arbitrary point-in-time, and presents a "wall time" (i.e. the time
> displayed by the clock on the wall) using, amongst other things, a set
> of adjustment rules codified by a zoneinfo file.  The number of second
> between 1 minute to- and midnight-ending 31 December is 61.  If Linux
> does not reflect that it is wrong and must be fixed.  If it isn't fixed
> we will increasingly discover a discrepancy between time-data that
> originates on Linux versus other, correct systems.
>
> I don't understand why such a simple thing was unnecessarily
> complicated.  And causing crashes!  Ha ha ha or what?  A simple addition
> to zoneinfo was (and still is) all that is required.

Leap seconds are an integral part of the NTP standard for the reasons
I described.  You can't "update zoneinfo" because a leap second is
applied to *all* timezones... not just a single one.  Specifically,
each NTP message includes some bits indicating what the next
leap-second is going to be (at the end of the current month), whether
+1, 0, or -1.

I believe that under Linux if you request a monotonic clock then you
won't "experience" leap-seconds at all; although such a clock will
probably stop while your computer is suspended.  On the other hand, if
you explicitly ask for a wall-clock, it is the responsibility of NTP
to keep the wall-clock accurate to the actual passage of days, even if
that involves slight slewing adjustments.

The UTC timezone is explicitly defined to include "leap seconds", and
so we cannot honestly claim to implement the standard unless we
provide a method for those leap seconds to be applied.  If you don't
want leap-seconds, submit a patch to the ntp daemon to allow it to run
in "UT1" mode in which it will ignore leap second notifications over
the NTP protocol, or just use a GPS clock.

Cheers,
Kyle Moffett
