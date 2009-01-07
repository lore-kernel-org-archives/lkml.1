Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbZAGOfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbZAGOfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 09:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbZAGOfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 09:35:43 -0500
Received: from mail2.ntp.org ([204.152.184.138]:57930 "EHLO mail2.ntp.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbZAGOfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 09:35:42 -0500
Message-ID: <4964BD76.9090700@ntp.isc.org>
Date: Wed, 07 Jan 2009 09:34:30 -0500
From: Danny Mayer <mayer@ntp.isc.org>
Reply-To: mayer@ntp.isc.org
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linasvepstas@gmail.com
Cc: david@lang.hm, Robert Hancock <hancockr@shaw.ca>,
       Ben Goodger <goodgerster@gmail.com>,
       Kyle Moffett <kyle@moffetthome.net>,
       MentalMooMan <slashdot@jameshallam.info>,
       David Newall <davidn@davidnewall.com>, linux-kernel@vger.kernel.org,
       ntpwg@lists.ntp.isc.org, Travis Crump <pretzalz@techhouse.org>,
       burdell@iruntheinter.net, Nick Andrew <nick@nick-andrew.net>,
       "Jeffrey J. Kosowsky" <jeff@kosowsky.org>
Subject: Re: [ntpwg] Bug: Status/Summary of slashdot leap-second crash on
 new years 2008-2009
References: <495F0672.6020708@davidnewall.com> <4961432A.80509@davidnewall.com>	 <alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm>	 <49614835.7000505@davidnewall.com>	 <3ae3aa420901042148o1c96985dube8e03085c997a07@mail.gmail.com>	 <20090105143335.GC18055@mail.local.tull.net>	 <3ae3aa420901050808r100e533fo5f88edfbb5f0747a@mail.gmail.com>	 <alpine.DEB.1.10.0901050949560.27641@asgard.lang.hm>	 <3ae3aa420901050942y56f0ecdei39c091a73e49c1fd@mail.gmail.com>	 <49642674.9080703@ntp.isc.org> <3ae3aa420901062052h75fcab11n8ce45c41ac0e4cd2@mail.gmail.com>
In-Reply-To: <3ae3aa420901062052h75fcab11n8ce45c41ac0e4cd2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-kostecke.net-MailScanner: Found to be clean
X-kostecke.net-MailScanner-From: mayer@ntp.isc.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linas Vepstas wrote:
> 2009/1/6 Danny Mayer <mayer@ntp.isc.org>:
> Hi,
> 
>> I don't know what this discussion is really about and why this was sent
>>  to the working group in the middle of the discussion, but there is no
>> need for NTP to provide TAI information since NTP only uses UTC. Leap
>> Seconds are automatically signaled  and incorporated when they become
>> due. If you don't have NTP running for some reason when a leap second is
>> signaled it doesn't matter since your server source will already have
>> incorporated the leap second so the NTP packet includes the timestamps
>> that include the leap second adjustment.
>>
>> Operating Systems use UTC and not TAI by universal agreement and the
>> ones that don't are extremely rare.
>>
>> Why don't you tell us what the real problem is instead of telling us
>> that you need TAI offset information?
> 
> Currently, the Linux kernel keeps time in UTC. This means
> that it must take special actions to tick twice when a leap
> second comes by.  Due to a (stupid) bug, some fraction
> of linux systems crashed; this includes everything from
> laptops to servers, to DVR's,  to cell phones and cell
> phone towers. There's now a fix for this.
> 
> However, during the discussion, the idea came out that
> maybe keeping UTC time in the kernel is just plain stupid.
> So there's this idea floating around that maybe the kernel
> should keep TAI time instead. The hope is that this will
> reduce the complexity in the kernel, and push it out to
> user space, "where it belongs" (to repeat a well-worn
> mantra).
> 
> However, *if* we were to kick UTC out of the kernel,
> and push it to user-land, then, of course, there's a
> different problem: how does the kernel know what the
> correct TAI time is?  As your reply makes abundantly
> clear, NTP is not a good source for TAI information.
> 
> The comments which you labelled as "non-sense" were
> a mis-understanding of  a discussion of a particular issue
> that would arise if the kernel were to keep TAI -- if it did,
> then user-space systems would need to have a reliable
> source for leap-seconds. Since NTP does not
> provide this, there was discussion about how that
> could be worked-around. This then lead to the comment
> that, "gee, wouldn't the right long-term solution be that
> NTP provide TAI info?"

It was nonsense because the summary didn't contain all of the
information required to provide context and you copied the Working Group
in the middle of all this.

NTP can provide leap-second information via an autokey protocol request,
 see Section 10.6 Leapseconds Values Message (LEAP)
http://www.ietf.org/internet-drafts/draft-ietf-ntp-autokey-04.txt but
that means you need to have autokey set up with another NTP server and
that means adding infrastructure that you probably don't want and are
not prepared to handle.

> 
> Clearly, it would be a lot of work to get the kernel to keep
> TAI instead of UTC, so this is not, at this time, a "serious
> proposal".  But if it were possible, and all the various
> little issues that result were solvable, then it does seem
> like a better long-term solution.
> 

This is a *lot* more complicated than you might think. If you are
thinking of implementing this similarly to the way timezone information
is added for display purposes, you need the whole list of leap seconds
and when the change happened since you now have to look at a timestamp
and see when it was and then apply all of the leapseconds up to that
point in time and none of the leapseconds beyond that. In addition, you
have legacy files that have UTC timestamps on them so you would need to
distinguish between UTC (legacy) and TAI timestamps in the file system
among other places (anywhere where a timestamp exists) and what would
you do about database tables which contain timestamps? The list goes on.

I'd much rather you spend the time tackling the clock interrupt losses
that many of our Linux users complain about. See:
https://support.ntp.org/bin/view/Support/KnownOsIssues#Section_9.2.4.
for some of the gorier details. I'm sure you don't really want us
recommending that they set HZ=100 in the kernel to alleviate the problem.

Danny

> --linas
> 
> p.s. the opinions above are not my own; I'm just
> summarizing the points made by the most vocal
> posters to this list.
> 
> 

