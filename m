Return-Path: <linux-kernel-owner+w=401wt.eu-S932501AbXCVJtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbXCVJtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 05:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932690AbXCVJtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 05:49:18 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2432 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932501AbXCVJtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 05:49:17 -0400
Message-ID: <46025100.7060103@shadowen.org>
Date: Thu, 22 Mar 2007 09:48:48 +0000
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>, "Martin J. Bligh" <mbligh@mbligh.org>,
       Con Kolivas <kernel@kolivas.org>
Subject: Re: 2.6.21-rc4-mm1
References: <20070319205623.299d0378.akpm@linux-foundation.org> <45FFAD50.8060108@shadowen.org> <4602413C.6000504@shadowen.org>
In-Reply-To: <4602413C.6000504@shadowen.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> Andy Whitcroft wrote:
>> Andrew Morton wrote:
>>> Temporarily at
>>>
>>>   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
>>>
>>> Will appear later at
>>>
>>>   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/
>>>
>>>
>>>
>> [All of the below is from the pre hot-fix runs.  The very few results
>> which are in for the hot-fix runs seem worse if anything.  :(  All
>> results should be out on TKO.]
>>
>>> - Restored the RSDL CPU scheduler (a new version thereof)
>> Unsure if the above is the culprit but there seems to be a smattering of
>> BUG's in kernbench from the schedular on several systems, and panics
>> which do not fully dump out.
>>
>> elm3b239 is about 2/4 kernbench being the test in progress when we
>> blammo in both failed tests, elm3b234 doesn't boot at all.
> 
> Well I have one result through for backing RSDL out on elm3b239 and that
> does indeed seem to give us a successful boot and test.  peterz has
> pointed me to an incremental patch from Con which I'll push through
> testing and see if that sorts it out.

Ok, tested the patch below on top of 2.6.21-rc4-mm1 and this seems to
fix the problem:

http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc4-mm1-rsdl-0.32.patch

Hard to tell from that patch whether it will be fixed in the changes
already committed to the next -mm.

Its possible that it may be fixed by the following patch:

    sched-rsdl-improvements.patch

Which has the following slipped in at the end of the changelog:

    A tiny change checking for MAX_PRIO in normal_prio()
    may prevent oopses on bootup on large SMP due to
    forking off the idle task.

Con, are all the changes in the 0.32 patch above with akpm?

-apw
