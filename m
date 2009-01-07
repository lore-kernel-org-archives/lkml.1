Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbZAGETg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbZAGETg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 23:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754803AbZAGET0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 23:19:26 -0500
Received: from mail2.ntp.org ([204.152.184.138]:51068 "EHLO mail2.ntp.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754891AbZAGETZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 23:19:25 -0500
X-Greylist: delayed 1708 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Jan 2009 23:19:25 EST
Message-ID: <49642674.9080703@ntp.isc.org>
Date: Tue, 06 Jan 2009 22:50:12 -0500
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
References: <495F0672.6020708@davidnewall.com>	<4960897D.5030603@davidnewall.com>	<alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm>	<4961432A.80509@davidnewall.com>	<alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm>	<49614835.7000505@davidnewall.com>	<3ae3aa420901042148o1c96985dube8e03085c997a07@mail.gmail.com>	<20090105143335.GC18055@mail.local.tull.net>	<3ae3aa420901050808r100e533fo5f88edfbb5f0747a@mail.gmail.com>	<alpine.DEB.1.10.0901050949560.27641@asgard.lang.hm> <3ae3aa420901050942y56f0ecdei39c091a73e49c1fd@mail.gmail.com>
In-Reply-To: <3ae3aa420901050942y56f0ecdei39c091a73e49c1fd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-kostecke.net-MailScanner: Found to be clean
X-kostecke.net-MailScanner-From: mayer@ntp.isc.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linas Vepstas wrote:
> 2009/1/5  <david@lang.hm>:
>> On Mon, 5 Jan 2009, Linas Vepstas wrote:
>>
>>>> Arguably the kernel's responsibility should be to keep track of the
>>>> most fundamental representation of time possible for a machine (that's
>>>> probably TAI) and it is a userspace responsibility to map from that
>>>> value to other time standards including UTC,
>>> Yes, this really does seem like the right solution.
>>>
>>>> using control files
>>>> which are updated as leap seconds are declared.
>>> Lets be clear on what "control files" means.  This does
>>> *NOT* mean some config file shipped by some distro
>>> for some package. That would be a horrid solution.
>>> People don't install updates, patches, etc.  Distros
>>> ship them late, or never, if the distro is old enough.
>>>
>>> A more appropriate solution would be to have
>>> either the kernel or ntpd track the leap seconds
>>> automatically.  First, the ntp protocol already provides
>>> the needed notification of a leap second to anyone
>>> who cares about it (i.e. there is no point in getting a
>>> Linux distro involved in this -- a distribution mechanism
>>> already exists, and works *better* than having a distro
>>> do it).
>> I disagree with this. NTP will only know about leap seconds if it was
>> running and connected to a server that advertised the leap seconds during
>> that month.
>>
>> for example, if you installed a new server today, how would it ever know
>> that there was a leap second a couple of days ago?

Because it gets it's time from an upstream server that already has
incorporated the leap second so it doesn't really need to know that the
leap second happened a few days ago or even a few years ago.

> OK, good point.  Unless your distro was less
> than a few days old (unlikely), you are faced with the
> same problem.  Sure, eventually, the distro will publish
> an update (which will add to the existing list of 36 leap
> seconds -- which is needed in any case, since no one
> has a server that's been up since 1958),  but this is
> unlikely to happen during this install window.
> 

This is nonsense. That's not how NTP works.

> The long term solution would be write an RFC to extend
> NTP to also provide TAI information -- e.g. to add a
> message that indicates the current leap-second offset
> between UTC and TAI.
> 
> --linas

I don't know what this discussion is really about and why this was sent
  to the working group in the middle of the discussion, but there is no
need for NTP to provide TAI information since NTP only uses UTC. Leap
Seconds are automatically signaled  and incorporated when they become
due. If you don't have NTP running for some reason when a leap second is
signaled it doesn't matter since your server source will already have
incorporated the leap second so the NTP packet includes the timestamps
that include the leap second adjustment.

Operating Systems use UTC and not TAI by universal agreement and the
ones that don't are extremely rare.

Why don't you tell us what the real problem is instead of telling us
that you need TAI offset information?

Danny
