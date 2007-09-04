Return-Path: <linux-kernel-owner+w=401wt.eu-S1755259AbXIDOmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbXIDOmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 10:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbXIDOlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 10:41:53 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:8404 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbXIDOlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 10:41:52 -0400
X-IronPort-AV: i="4.20,207,1186372800"; 
   d="scan'208"; a="38851230:sNHT913746134"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: the Linux kernel, testsuites, and maybe *you*
Date: Tue, 4 Sep 2007 10:41:31 -0400
User-Agent: KMail/1.9.5
Cc: "Mike Frysinger" <vapier.adi@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
References: <8bd0f97a0708311422u309ff09cs24dfe64ff535a982@mail.gmail.com> <p733axyxcli.fsf@bingen.suse.de>
In-Reply-To: <p733axyxcli.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709041041.31353.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 04 Sep 2007 14:41:21.0217 (UTC) FILETIME=[A8F7DB10:01C7EF01]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 1 Sep 2007 18:08, Andi Kleen pondered:
> "Mike Frysinger" <vapier.adi@gmail.com> writes:
> 
> > is there any sort of standard for testing and integration into
> > mainline ?  
> 
> Everybody does their own.

That kind of stinks - and seems to be a potential duplication of effort all 
over the place.

> > in the Blackfin world, we've been developing little
> > external kernel modules and adding them to our own testsuite, but
> > often times these things are not Blackfin specific.  case in point,
> > we're integrating a string testsuite to make sure all of the fun str*
> > and mem* functions are sane and operate as they expected, but rather
> > than having just Blackfin benefit here, i'd like to see this pushed
> > upstream ...
> 
> I would like to see this too. I wrote a couple of unit tests
> during x86-64 development too and they would be handy
> to have in a central place.
> 
> The SUSE kernel also has a crasher module that exercises the
> allocators and is pretty useful to stress code in general.
> 
> Disadvantage is that test code tends to be hackish and ugly
> and very specialized and will probably not pass standard review
> procedures.

Then this makes perfect sense to actually have it in the proper places, and 
have it go through the standard review process. I have run into problems 
recently, where ugly hackish tests seem never really catch actual faults. 
(Since they were written by the same person who wrote the driver - Design a 
fault in, code the fault, test the fault is there).

With many eyes - and all that stuff - hopefully we would catch things.

> Also the rt people seem to have pushed a couple of tests in already, 
> but I always hated it that they're in the standard directories.
> RCU also has, in fact they added a "eat all my CPU in tests"
> CONFIG option. Just making that dependent on a CONFIG_UNIT_TESTS
> would be a good change in itself. And then there are the slab
> failure inducers of course.

Putting them close to the standard directories might be OK - keeping the tests 
close to the thing that is being tested may help with maintainers keeping an 
eye on things that might be missed otherwise.

Maybe these types of tests should go into a separate directory - power on self 
tests (post) directories in the respective places? ./kernel/post 
and ./drivers/xxxx/post?

So Mike's proposed string tests would go into ./lib/post/strings.c

When things pass - you get a single indication (all tests for unit X passed) 
or a pass for each test?

-Robin
