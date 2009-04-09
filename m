Return-Path: <linux-kernel-owner+w=401wt.eu-S1765536AbZDIKsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765536AbZDIKsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 06:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760367AbZDIKsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 06:48:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38392 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764478AbZDIKsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 06:48:31 -0400
Message-ID: <49DDD26A.2090901@redhat.com>
Date: Thu, 09 Apr 2009 06:48:10 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>
CC: Jens Axboe <jens.axboe@oracle.com>,
       device-mapper development <dm-devel@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ak@linux.intel.com, "MASON, CHRISTOPHER" <CHRIS.MASON@oracle.com>
Subject: Re: [dm-devel] Barriers still not passing on simple dm devices...
References: <20090324143034.GW27476@kernel.dk> <Pine.LNX.4.64.0903241033070.4088@hs20-bc2-1.build.redhat.com> <20090324150517.GX27476@kernel.dk> <Pine.LNX.4.64.0903251106520.27750@hs20-bc2-1.build.redhat.com> <20090325152751.GV27476@kernel.dk> <Pine.LNX.4.64.0903251825310.8027@hs20-bc2-1.build.redhat.com> <20090326084205.GG27476@kernel.dk> <Pine.LNX.4.64.0903302314500.6158@hs20-bc2-1.build.redhat.com> <20090331104933.GJ5178@kernel.dk> <Pine.LNX.4.64.0904021923040.19415@hs20-bc2-1.build.redhat.com> <20090403081131.GP5178@kernel.dk> <49D77AC3.3020207@redhat.com> <Pine.LNX.4.64.0904080844550.28196@hs20-bc2-1.build.redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904080844550.28196@hs20-bc2-1.build.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas Patocka wrote:
>> And I will restate that back at EMC we tested the original barriers (with
>> reiserfs mostly, a bit on ext3 and ext2) and saw significant reduction in file
>> system integrity issues after power loss.
>>     
>
> You saw that barrier-enabled filesystem was worse than the same filesystem 
> without barriers? And what kind of issues were that? Disks writing damaged 
> sectors if powered-off in the middle of the writes? Or data corruptions 
> due to bugs in ReiserFS?
>   

No - I was not being clear. We saw a reduction in issues which is a 
confusing way to say that it was significantly better with barriers 
enabled, for both ext3 & reiserfs.

>   
>> The vantage point I had at EMC while testing and deploying the original
>> barrier work done by Jens and Chris was pretty unique - full ability to do
>> root cause failures of any component when really needed, a huge installed base
>> which could send information home on a regular basis about crashes/fsck
>> instances/etc and the ability (with customer permission) to dial into any box
>> and diagnose issues remotely. Not to mention access to drive vendors to
>> pressure them to make the flushes more robust. The application was also able
>> to validate that all acknowledged writes were consistent.
>>
>> Barriers do work as we have them, but as others have mentioned, it is not a
>> "free" win - fsync will actually move your data safely out to persistent
>> storage for a huge percentage of real users (including every ATA/S-ATA and SAS
>> drive I was able to test).  The file systems I monitored in production use
>> without barriers were much less reliable.
>>     
>
> With write cache or without write cache?
>   
Write cache enabled.

Barriers are off when write cache is disabled - we probe the drives 
write cache and enable barriers at mount time if and only if the 
barriers are on.
> With cache and without barriers the system is violating the specification. 
> There just could be data corruption ... and it will eventually happen.
>
> If you got corruption without cache and without barriers, there's a bug 
> and it needs to be investigated.
>
>   
>> As others have noted, some storage does not need barriers or flushed (high end
>> arrays, drives with no volatile write cache) and some need it but stink (low
>> cost USB flash sticks?) so warning is a good thing to do...
>>
>> ric
>>     
>
> Mikulas
>   

