Return-Path: <linux-kernel-owner+w=401wt.eu-S1761290AbZAGTYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761290AbZAGTYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 14:24:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbZAGTYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 14:24:37 -0500
Received: from mail2.ntp.org ([204.152.184.138]:61846 "EHLO mail2.ntp.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbZAGTYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 14:24:35 -0500
Message-ID: <4965013F.908@ntp.isc.org>
Date: Wed, 07 Jan 2009 14:23:43 -0500
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
References: <495F0672.6020708@davidnewall.com>	 <49614835.7000505@davidnewall.com>	 <3ae3aa420901042148o1c96985dube8e03085c997a07@mail.gmail.com>	 <20090105143335.GC18055@mail.local.tull.net>	 <3ae3aa420901050808r100e533fo5f88edfbb5f0747a@mail.gmail.com>	 <alpine.DEB.1.10.0901050949560.27641@asgard.lang.hm>	 <3ae3aa420901050942y56f0ecdei39c091a73e49c1fd@mail.gmail.com>	 <49642674.9080703@ntp.isc.org>	 <3ae3aa420901062052h75fcab11n8ce45c41ac0e4cd2@mail.gmail.com>	 <4964BD76.9090700@ntp.isc.org> <3ae3aa420901070742t8639479qe52cdb615bf46237@mail.gmail.com>
In-Reply-To: <3ae3aa420901070742t8639479qe52cdb615bf46237@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-kostecke.net-MailScanner: Found to be clean
X-kostecke.net-MailScanner-From: mayer@ntp.isc.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linas Vepstas wrote:
> [...]
> 
>>>   a discussion of a particular issue
>>> that would arise if the kernel were to keep TAI -- if it did,
>>> then user-space systems would need to have a reliable
>>> source for leap-seconds. Since NTP does not
>>> provide this, there was discussion about how that
>>> could be worked-around. This then lead to the comment
>>> that, "gee, wouldn't the right long-term solution be that
>>> NTP provide TAI info?"
>> NTP can provide leap-second information via an autokey protocol request,
>>  see Section 10.6 Leapseconds Values Message (LEAP)
>> http://www.ietf.org/internet-drafts/draft-ietf-ntp-autokey-04.txt but
> 
> Yes, that look like exactly what would be wanted.  It would be nice
> if such a message was available in the regular, non-encrypted protocol.

It's not encrypted, it's an authentication protocol. You really do need
to know that you are receiving a reliable set of information otherwise
anyone can spoof you with bad data and play havoc with your clock and
timestamps.

>> that means you need to have autokey set up with another NTP server and
>> that means adding infrastructure that you probably don't want and are
>> not prepared to handle.
> 
> Heh. Yes, well, I still haven't figured out how to secure DNS. Yet clearly
> this whole security mess must march on, and somehow the security
> infrastructure must eventually become easy to install.
> 
<DNS hat>
That's pretty easy. Install BIND 9.6.0. Read the DNSSEC deployment
instructions here: https://www.isc.org/files/DNSSEC_in_6_minutes.pdf and
implement. You should be done in almost no time.
</DNS hat>

>>> Clearly, it would be a lot of work to get the kernel to keep
>>> TAI instead of UTC, so this is not, at this time, a "serious
>>> proposal".  But if it were possible, and all the various
>>> little issues that result were solvable, then it does seem
>>> like a better long-term solution.
>>>
>> This is a *lot* more complicated than you might think. If you are
>> thinking of implementing this similarly to the way timezone information
>> is added for display purposes, you need the whole list of leap seconds
>> and when the change happened since you now have to look at a timestamp
>> and see when it was and then apply all of the leapseconds up to that
>> point in time and none of the leapseconds beyond that. In addition, you
>> have legacy files that have UTC timestamps on them so you would need to
>> distinguish between UTC (legacy) and TAI timestamps in the file system
>> among other places (anywhere where a timestamp exists) and what would
>> you do about database tables which contain timestamps? The list goes on.
> 
> Yes.
> 
>> I'd much rather you spend the time tackling the clock interrupt losses
>> that many of our Linux users complain about. See:
>> https://support.ntp.org/bin/view/Support/KnownOsIssues#Section_9.2.4.
>> for some of the gorier details. I'm sure you don't really want us
>> recommending that they set HZ=100 in the kernel to alleviate the problem.
> 
> Actually, this is rather sorely lacking in 'gory details', rather, its
> a complaint
> that 'things don't work' with no discussion of the actual problem.  It would
> be much better if there was a link to any previous discussions on LKML on
> this issue.

Sorry, but that's not my area of expertise. I just know we have many
people running Linux and have these issues.

> 
> My knee-jerk reaction on reading about the lost-interrupts issue is that,
> yes, setting HZ=100 and disabling ACPI is indeed a decent short-term
> work-around (APIC is something completely different and not something
> you can disable). The correct long-term solution would be to use real-time
> kernels, which are designed to make sure that things like lost interrupts
> never happen.
> 

I bow to your superior knowledge in this area.

Danny
