Return-Path: <linux-kernel-owner+w=401wt.eu-S1759438AbZAGPnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759438AbZAGPnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 10:43:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbZAGPm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 10:42:56 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:8567 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbZAGPmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 10:42:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=ID3F912vNxeAJX6N4K4HdqseWuzJxXMBbF/YqtHarJzk+UObSDq3yPCUiN2GGCaj2z
         lcVeSbd9Ma6IsyNdpcQ0FZsdFKftOHwEHgZCaGEn0nlahPQCQu2UpNgG1JBCu9oSUCF1
         y+tLWBqeGnfM5i4nH00V3gkMGxAgBh4Lk6l9A=
Message-ID: <3ae3aa420901070742t8639479qe52cdb615bf46237@mail.gmail.com>
Date: Wed, 7 Jan 2009 09:42:53 -0600
From: "Linas Vepstas" <linasvepstas@gmail.com>
Reply-To: linasvepstas@gmail.com
To: mayer@ntp.isc.org
Subject: Re: [ntpwg] Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
Cc: david@lang.hm, "Robert Hancock" <hancockr@shaw.ca>,
       "Ben Goodger" <goodgerster@gmail.com>,
       "Kyle Moffett" <kyle@moffetthome.net>,
       MentalMooMan <slashdot@jameshallam.info>,
       "David Newall" <davidn@davidnewall.com>, linux-kernel@vger.kernel.org,
       ntpwg@lists.ntp.isc.org, "Travis Crump" <pretzalz@techhouse.org>,
       burdell@iruntheinter.net, "Nick Andrew" <nick@nick-andrew.net>,
       "Jeffrey J. Kosowsky" <jeff@kosowsky.org>
In-Reply-To: <4964BD76.9090700@ntp.isc.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <495F0672.6020708@davidnewall.com>
	 <49614835.7000505@davidnewall.com>
	 <3ae3aa420901042148o1c96985dube8e03085c997a07@mail.gmail.com>
	 <20090105143335.GC18055@mail.local.tull.net>
	 <3ae3aa420901050808r100e533fo5f88edfbb5f0747a@mail.gmail.com>
	 <alpine.DEB.1.10.0901050949560.27641@asgard.lang.hm>
	 <3ae3aa420901050942y56f0ecdei39c091a73e49c1fd@mail.gmail.com>
	 <49642674.9080703@ntp.isc.org>
	 <3ae3aa420901062052h75fcab11n8ce45c41ac0e4cd2@mail.gmail.com>
	 <4964BD76.9090700@ntp.isc.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the reply.

2009/1/7 Danny Mayer <mayer@ntp.isc.org>:
> Linas Vepstas wrote:
>> 2009/1/6 Danny Mayer <mayer@ntp.isc.org>:
>>> Why don't you tell us what the real problem is instead of telling us
>>> that you need TAI offset information?
>>
>> Currently, the Linux kernel keeps time in UTC. This means
>> that it must take special actions to tick twice when a leap
>> second comes by.  Due to a (stupid) bug, some fraction
>> of linux systems crashed; this includes everything from
>> laptops to servers, to DVR's,  to cell phones and cell
>> phone towers. There's now a fix for this.
>>
>> However, during the discussion, the idea came out that
>> maybe keeping UTC time in the kernel is just plain stupid.
>> So there's this idea floating around that maybe the kernel
>> should keep TAI time instead. The hope is that this will
>> reduce the complexity in the kernel, and push it out to
>> user space, "where it belongs" (to repeat a well-worn
>> mantra).
>>
>> However, *if* we were to kick UTC out of the kernel,
>> and push it to user-land, then, of course, there's a
>> different problem: how does the kernel know what the
>> correct TAI time is?  As your reply makes abundantly
>> clear, NTP is not a good source for TAI information.

[...]

>>   a discussion of a particular issue
>> that would arise if the kernel were to keep TAI -- if it did,
>> then user-space systems would need to have a reliable
>> source for leap-seconds. Since NTP does not
>> provide this, there was discussion about how that
>> could be worked-around. This then lead to the comment
>> that, "gee, wouldn't the right long-term solution be that
>> NTP provide TAI info?"
>
> NTP can provide leap-second information via an autokey protocol request,
>  see Section 10.6 Leapseconds Values Message (LEAP)
> http://www.ietf.org/internet-drafts/draft-ietf-ntp-autokey-04.txt but

Yes, that look like exactly what would be wanted.  It would be nice
if such a message was available in the regular, non-encrypted protocol.

> that means you need to have autokey set up with another NTP server and
> that means adding infrastructure that you probably don't want and are
> not prepared to handle.

Heh. Yes, well, I still haven't figured out how to secure DNS. Yet clearly
this whole security mess must march on, and somehow the security
infrastructure must eventually become easy to install.

>> Clearly, it would be a lot of work to get the kernel to keep
>> TAI instead of UTC, so this is not, at this time, a "serious
>> proposal".  But if it were possible, and all the various
>> little issues that result were solvable, then it does seem
>> like a better long-term solution.
>>
>
> This is a *lot* more complicated than you might think. If you are
> thinking of implementing this similarly to the way timezone information
> is added for display purposes, you need the whole list of leap seconds
> and when the change happened since you now have to look at a timestamp
> and see when it was and then apply all of the leapseconds up to that
> point in time and none of the leapseconds beyond that. In addition, you
> have legacy files that have UTC timestamps on them so you would need to
> distinguish between UTC (legacy) and TAI timestamps in the file system
> among other places (anywhere where a timestamp exists) and what would
> you do about database tables which contain timestamps? The list goes on.

Yes.

> I'd much rather you spend the time tackling the clock interrupt losses
> that many of our Linux users complain about. See:
> https://support.ntp.org/bin/view/Support/KnownOsIssues#Section_9.2.4.
> for some of the gorier details. I'm sure you don't really want us
> recommending that they set HZ=100 in the kernel to alleviate the problem.

Actually, this is rather sorely lacking in 'gory details', rather, its
a complaint
that 'things don't work' with no discussion of the actual problem.  It would
be much better if there was a link to any previous discussions on LKML on
this issue.

My knee-jerk reaction on reading about the lost-interrupts issue is that,
yes, setting HZ=100 and disabling ACPI is indeed a decent short-term
work-around (APIC is something completely different and not something
you can disable). The correct long-term solution would be to use real-time
kernels, which are designed to make sure that things like lost interrupts
never happen.

I have no idea what the status of real-time Linux is, whether it would now
have gaurantees for timer ticks, and whether anything there would now
be mergeable into the mainline kernel.

--linas
