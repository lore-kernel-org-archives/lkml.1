Return-Path: <linux-kernel-owner+w=401wt.eu-S1762914AbZAHUj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762914AbZAHUj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 15:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbZAHUjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 15:39:17 -0500
Received: from zilan.ucolick.org ([128.114.23.234]:41741 "EHLO
	smtp.ucolick.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817AbZAHUjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 15:39:16 -0500
X-Greylist: delayed 1774 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jan 2009 15:39:16 EST
Date: Thu, 8 Jan 2009 12:09:34 -0800
From: Steve Allen <sla@ucolick.org>
To: "M. Warner Losh" <imp@bsdimp.com>
Cc: mayer@ntp.isc.org, david@lang.hm, hancockr@shaw.ca, kyle@moffetthome.net,
       slashdot@jameshallam.info, goodgerster@gmail.com,
       davidn@davidnewall.com, linux-kernel@vger.kernel.org,
       ntpwg@lists.ntp.isc.org, pretzalz@techhouse.org,
       burdell@iruntheinter.net, linasvepstas@gmail.com, nick@nick-andrew.net,
       jeff@kosowsky.org
Subject: Re: [ntpwg] Bug: Status/Summary of slashdot leap-second crash on  new years 2008-2009
Message-ID: <20090108200934.GA18773@ucolick.org>
Reply-To: Leap Second Discussion List <leapsecs@leapsecond.com>
References: <alpine.DEB.1.10.0901050949560.27641@asgard.lang.hm> <3ae3aa420901050942y56f0ecdei39c091a73e49c1fd@mail.gmail.com> <49642674.9080703@ntp.isc.org> <20090107.103947.1324582654.imp@bsdimp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107.103947.1324582654.imp@bsdimp.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-01-07T10:39:47 -0700, M. Warner Losh hath writ:
> The suggestion to solving this would be to tick in TAI time, and force
> userland to cope with the leapsecond issues.  Of course, there's a
> number of problems with this solution as well, but it feels like it
> belongs there...

Agreed that the leap second belong in userland, but BIPM itself
refuses to agree with the idea of the underlying time scale being TAI.
TAI has no standing as an international recommendation, and it is not
available via the established broadcast mechanisms, and BIPM does not
want those things to happen.  What would be needed is a leap-free time
scale with an international recommendation standing behind it so as to
legitimize its use.

The most recent public insight to the ITU-R process of reconsidering
leap seconds in UTC is from September, here
http://www.navcen.uscg.gov/cgsic/meetings/48thmeeting/Reports/Timing%20Subcommittee/48-LS%2020080916.pdf
In the schedule given on page 16 we see that even if the ITU-R process
goes smoothly there will be leap seconds at least until 2017, so we
have to live with them for at least that long.  However, at the
October meeting of ITU-R WP7A things did not go smoothly.  There were
two countries objecting to any change to UTC, so the process of
considering any change to the broadcast time scale is stalled.

Basically, any change to UTC is currently stalled by the
international political/diplomatic process which controls it.

Way back in 2003 the ITU-R asked for advice on the broadcast time
scale, and the advice from the experts included changing the name if
leaps are dropped.
http://www.inrim.it/luc/cesio/itu/closure.pdf
At that point nobody managed to point out that POSIX demands that the
zoneinfo mechanisms allow for offsets of seconds as well as minutes,
so there was no clear path for implementing that advice while
preserving compliance with specifications that still demand UTC.

Any epoch-based time scale has issues with UTC as it has been defined
http://www.ucolick.org/~sla/leapsecs/epochtime.html
and by ignoring leap seconds POSIX makes that even harder to implement.
During the past century we have seen the creation of at least 4
different uniform time scales, two of which are widely available by
broacast (LORAN-C and GPS), but none of which has the backing of an
international standard behind it.
http://www.ucolick.org/~sla/leapsecs/deltat.html

All civil time scales are conventional constructs, and zoneinfo is
designed to handle the arbitrary nature of changes to civil time.  If
the underlying time scale changes its name and stops having leaps,
then leap seconds in UTC are just another form of conventional change
to civil time.  UTC could become a time zone.  Processes which happen
when POSIX time_t % 86400 == 0 would happen at "atomic midnight"
instead of "civil" midnight, not a big difference.

If the ITU-R were to take the advice of the colloquium it organized,
if they were to abandon the name UTC, and establish a new
international broadcast time scale with a new name, then the
operational systems of the world receiving those broadcasts would not
notice.  There would be some rewriting of documents, specifications,
and some extra work streamlining zoneinfo.

It's not just an engineering tradeoff, it's a political tradeoff.
The question for the NTP implementors, kernel hackers, application
writers is whether it's worth waiting to see if the current political
impasse about UTC can be broken, or whether it seems better, easier,
and quicker to lobby the ITU-R delegations to abandon the name UTC
and give a new name to a broadcast time scale without leaps.

Either way we will have to handle another decade of leap seconds
before the broadcast time scale can change its characteristics.

replies directed to the LEAPSECS list

--
Steve Allen                 <sla@ucolick.org>                WGS-84 (GPS)
UCO/Lick Observatory        Natural Sciences II, Room 165    Lat  +36.99855
University of California    Voice: +1 831 459 3046           Lng -122.06015
Santa Cruz, CA 95064        http://www.ucolick.org/~sla/     Hgt +250 m
