Return-Path: <linux-kernel-owner+w=401wt.eu-S1756188AbYIYUdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbYIYUdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 16:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbYIYUdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 16:33:32 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:61104 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953AbYIYUda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 16:33:30 -0400
Message-ID: <48DBF583.3050307@oracle.com>
Date: Thu, 25 Sep 2008 13:33:07 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       lkml <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: Re: in 2.6.23-rc3-git7 in do_cciss_intr
References: <20080821091514.8f56e2d5.randy.dunlap@oracle.com> <0F5B06BAB751E047AB5C87D1F77A778835118100D6@GVW0547EXC.americas.hpqcorp.net> <20080821172653.3e3e855c.randy.dunlap@oracle.com> <0F5B06BAB751E047AB5C87D1F77A77883511810706@GVW0547EXC.americas.hpqcorp.net> <1219420487.3339.22.camel@localhost.localdomain> <48AEEE0A.1010900@oracle.com> <1219424538.3339.51.camel@localhost.localdomain> <0F5B06BAB751E047AB5C87D1F77A77883511810894@GVW0547EXC.americas.hpqcorp.net> <48C013D9.7060309@oracle.com> <0F5B06BAB751E047AB5C87D1F77A7788413663D229@GVW0547EXC.americas.hpqcorp.net> <20080905092838.GS20055@kernel.dk>
In-Reply-To: <20080905092838.GS20055@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Thu, Sep 04 2008, Miller, Mike (OS Dev) wrote:
>>>>>> 0x3bb2 <do_cciss_intr+1649>:    mov    0x2(%r8),%dx
>>>>>> 0x3bb7 <do_cciss_intr+1654>:    test   %dx,%dx
>>>>>> 0x3bba <do_cciss_intr+1657>:    je     0x3f0e <do_cciss_intr+2509>
>>>>>>
>>>>>>
>>>>>> $ addr2line -e cciss.o -f  do_cciss_intr+0x627 SA5_fifo_full
>>>>>>
>>> /home/rdunlap/linsrc/linux-2.6.27-rc3-git7/drivers/block/cciss.h:206
>>>>> OK ...that's confusing.  It seems to be saying that ctrlr_info_t *
>>>>> was NULL.  However, I can't see a way of getting into the
>>> fifo_full
>>>>> callback from do_cciss_intr ..
>>>>> especially not with an NULL host.
>>>>>
>>>>> James
>>>> That is weird. Even if we could get there fifo_full doesn't
>>> do anything but wait for a bit.
>>>
>>> Hi,
>>>
>>> This just happened again.  This time it's on 2.6.27-rc5-git3.
>>>
>>> ~Randy
>> Thanks Randy. I think. :)
>>
>> I'll try to recreate in my lab.
> 
> This looks somewhat strange, mostly like 'c' is NULL and it's oopsing in
> in removeQ (I don't think Randy's analysis is correct in assuming it's
> 'h' and it's in fifo_full). Given that 'c' cannot be NULL, it's c->prev
> or c->next that are NULL.

Yes, correct IMO.  I checked my daily test logs and I have had this problem
in do_cciss_intr() 3 times, all at the same location, which appears to be
in removeQ(), as Jens says.


-- 
~Randy
