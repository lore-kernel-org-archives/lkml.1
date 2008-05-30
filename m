Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbYE3MnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbYE3MnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 08:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbYE3Mm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 08:42:57 -0400
Received: from mail.tmr.com ([64.65.253.246]:50455 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbYE3Mm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 08:42:56 -0400
Message-ID: <483FF92F.6060309@tmr.com>
Date: Fri, 30 May 2008 08:55:11 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: Holger Kiehl <Holger.Kiehl@dwd.de>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Performance Characteristics of All Linux RAIDs (mdadm/bonnie++)
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan> <Pine.LNX.4.64.0805290636020.20192@diagnostix.dwd.de> <alpine.DEB.1.10.0805291302190.23633@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0805291302190.23633@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
>
>
> On Thu, 29 May 2008, Holger Kiehl wrote:
>
>> On Wed, 28 May 2008, Justin Piszcz wrote:
>>
>>> Hardware:
>>>
>>> 1. Utilized (6) 400 gigabyte sata hard drives.
>>> 2. Everything is on PCI-e (965 chipset & a 2port sata card)
>>>
>>> Used the following 'optimizations' for all tests.
>>>
>>> # Set read-ahead.
>>> echo "Setting read-ahead to 64 MiB for /dev/md3"
>>> blockdev --setra 65536 /dev/md3
>>>
>>> # Set stripe-cache_size for RAID5.
>>> echo "Setting stripe_cache_size to 16 MiB for /dev/md3"
>>> echo 16384 > /sys/block/md3/md/stripe_cache_size
>>>
>>> # Disable NCQ on all disks.
>>> echo "Disabling NCQ on all disks..."
>>> for i in $DISKS
>>> do
>>>  echo "Disabling NCQ on $i"
>>>  echo 1 > /sys/block/"$i"/device/queue_depth
>>> done
>>>
>>> Software:
>>>
>>> Kernel: 2.6.23.1 x86_64
>>> Filesystem: XFS
>>> Mount options: defaults,noatime
>>>
>>> Results:
>>>
>>> http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.html
>>> http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.txt
>>>
>> Why is the Sequential Output (Block) for raid6 165719 and for raid5 only
>> 86797? I would have thought that raid6 was always a bit slower in 
>> writting
>> due to having to write double amount of parity data.
>>
>> Holger
>>
>
> RAID5 (2nd test of 3 averaged runs) & Single disk added:
> http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.html 

Other than repeating my (possibly lost) comment that this would be 
vastly easier to read if the number were aligned and all had the same 
number of decimal places in a single column, good stuff. For sequential 
i/o the winners and losers are clear, and you can set cost and 
performance to pick the winners. Seems obvious that raid-1 is the loser 
for single threaded load, I suspect that it would be poor against other 
levels in multithread loads, but not so much for read.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


