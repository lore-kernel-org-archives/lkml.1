Return-Path: <linux-kernel-owner+w=401wt.eu-S965469AbXCLKFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965469AbXCLKFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 06:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965470AbXCLKFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 06:05:05 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:49099 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965469AbXCLKFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 06:05:03 -0400
Date: Mon, 12 Mar 2007 06:04:42 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: RSDL for 2.6.21-rc3- 0.29
In-reply-to: <200703120237.39477.gene.heskett@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Con Kolivas <kernel@kolivas.org>, amanda-hackers@amanda.org,
       Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>, ck@vds.kolivas.org
Message-id: <200703120604.42776.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <20070311013506.GD10459@waste.org>
 <200703121648.22734.kernel@kolivas.org>
 <200703120237.39477.gene.heskett@gmail.com>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2007, Gene Heskett wrote:
>On Monday 12 March 2007, Con Kolivas wrote:
>>Hi Gene.
>>
>>On Monday 12 March 2007 16:38, Gene Heskett wrote:
>>> I hate to say it Con, but this one seems to have broken the
>>> amanda-tar symbiosis.
>>>
>>> I haven't tried a plain 21-rc3, so the problem may exist there, and
>>> in fact it did for 21-rc1, but I don't recall if it was true for
>>> -rc2. But I will have a plain 21-rc3 running by tomorrow nights
>>> amanda run to test.
>>>
>>> What happens is that when amanda tells tar to do a level 1 or 2, tar
>>> still thinks its doing a level 0.  The net result is that the tape is
>>> filled completely and amanda does an EOT exit in about 10 of my 42
>>> dle's.  This is tar-1.15-1 for fedora core 6.
>>
>>I'm sorry but I have to say I have no idea what any of this means. I
>> gather you're making an association between some application
>> combination failing and RSDL cpu scheduler. Unfortunately the details
>> of what the problem is, or how the cpu scheduler is responsible,
>> escape me :(
>
>I have another backup running right now, after building a plain
>2.6.21-rc3, and rebooting just now for the test.  I don't think its the
>scheduler itself, but is something post 2.6.20 that is messing with tars
>mind and making it think the files it just read to do the estimate
> phase, are all new, so even a level 2 is in effect a level 0.  I'll
> have an answer in about an hour, but its also 2:36am here and I'm
> headed for the rack to get some zzz's.  So I'll report in the morning
> as to whether or not this backup ran as it was supposed to.  I have a
> feeling its not going to though.

I can confirm that a plain 21-rc3 still suffers from this problem.  This 
run of amanda terminated after 13 of the 32 dle's after writing just 
short of 12GB to the vtape. 8 were level 0's, 5 were level 1's, all were 
gzipped, achieving a compression ratio of 40% of original size.  There is 
about 45GB of data here to backup, on a 5 day dumpcycle.

If, and I have previously, I revert to a 2.6.20-ck1 patching, this does 
not occur.  So my contention is that someplace in this recent progression 
from 2.6.20 to 2.6.21-rc3, there is a patch which acts to change how 
c-time is being reported to tar.  Or there is a spillage into c-times 
when tar does its estimate scans where the output goes to /dev/null.
Or possibly even this version of tar is doing it differently.  I just 
looked up how to get the c-times out of ls, and they, as far as ls is 
concerned, look sane.  But tars actions while running a 2.6.21-rcX kernel 
certainly are not.  I do have a plain -rc2 I can try, so that will be the 
next test.  If that also fails in this manner, I'll build a later 
2.6.20-2 or whatever to verify that it doesn't so suffer.

I love your patches Con, but I'll leave them out of this next testing.  No 
use pointing fingers at good code.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Mal: "Well, you were right about this being a bad idea."

Zoe: "Thanks for sayin', sir."
				--Episode #1, "Serenity"
