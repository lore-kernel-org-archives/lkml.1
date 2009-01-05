Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbZAEQuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbZAEQuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 11:50:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbZAEQtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 11:49:49 -0500
Received: from mail.lang.hm ([64.81.33.126]:53068 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254AbZAEQts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 11:49:48 -0500
Date: Mon, 5 Jan 2009 09:51:30 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Linas Vepstas <linasvepstas@gmail.com>
cc: Nick Andrew <nick@nick-andrew.net>, David Newall <davidn@davidnewall.com>,
       Kyle Moffett <kyle@moffetthome.net>,
       Ben Goodger <goodgerster@gmail.com>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org, "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       Travis Crump <pretzalz@techhouse.org>, burdell@iruntheinter.net
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years
 2008-2009
In-Reply-To: <3ae3aa420901050808r100e533fo5f88edfbb5f0747a@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0901050949560.27641@asgard.lang.hm>
References: <495F0672.6020708@davidnewall.com>  <496076A9.7030907@davidnewall.com>  <f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com>  <4960897D.5030603@davidnewall.com>  <alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm>  <4961432A.80509@davidnewall.com>
  <alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm>  <49614835.7000505@davidnewall.com>  <3ae3aa420901042148o1c96985dube8e03085c997a07@mail.gmail.com>  <20090105143335.GC18055@mail.local.tull.net>
 <3ae3aa420901050808r100e533fo5f88edfbb5f0747a@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009, Linas Vepstas wrote:

>> Arguably the kernel's responsibility should be to keep track of the
>> most fundamental representation of time possible for a machine (that's
>> probably TAI) and it is a userspace responsibility to map from that
>> value to other time standards including UTC,
>
> Yes, this really does seem like the right solution.
>
>> using control files
>> which are updated as leap seconds are declared.
>
> Lets be clear on what "control files" means.  This does
> *NOT* mean some config file shipped by some distro
> for some package. That would be a horrid solution.
> People don't install updates, patches, etc.  Distros
> ship them late, or never, if the distro is old enough.
>
> A more appropriate solution would be to have
> either the kernel or ntpd track the leap seconds
> automatically.  First, the ntp protocol already provides
> the needed notification of a leap second to anyone
> who cares about it (i.e. there is no point in getting a
> Linux distro involved in this -- a distribution mechanism
> already exists, and works *better* than having a distro
> do it).

I disagree with this. NTP will only know about leap seconds if it was 
running and connected to a server that advertised the leap seconds during 
that month.

for example, if you installed a new server today, how would it ever know 
that there was a leap second a couple of days ago?

David Lang

> If the kernel needs to track leap seconds, it could do
> so using a mechanism similar to the "random pool"
> that is saved across reboots.  Alternately, ntpd already
> stores slew rates &etc. in files, and could track leap
> seconds likewise.
>
>> Just so long as the
>> existing behaviour of time() which doesn't recognise leap seconds
>> is preserved.
>
> Well, 'man 2 time' is as clear as mud. It talks about leap seconds,
> but I can't figure out what its saying.  I rather
> doubt that time() is doing what POSIX.1 seems to want
> it to do (which is to ignore leap seconds?)
>
> The reason I'm guessing that time() is wrong, is because
> it seems that POSIX wants time() to use TAI time, and
> we don't have that handy anywhere (because we've lost
> track of those leap seconds)
>
> --linas
>
