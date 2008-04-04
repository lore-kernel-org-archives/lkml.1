Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbYDDHu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbYDDHu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 03:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753682AbYDDHtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 03:49:52 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:27388 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbYDDHtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 03:49:52 -0400
Message-ID: <47F5DD4E.40906@oracle.com>
Date: Fri, 04 Apr 2008 13:18:30 +0530
From: Gurudas Pai <gurudas.pai@oracle.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Nish Aravamudan <nish.aravamudan@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [BUG]:2.6.25-rc7 memory leak with hugepages.
References: <47EB4E2A.1040507@oracle.com> <20080327083849.GF15626@elte.hu>	 <47EB75C5.20207@oracle.com> <29495f1d0804032040h56f39051lcd5f707660d3c06c@mail.gmail.com>
In-Reply-To: <29495f1d0804032040h56f39051lcd5f707660d3c06c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Nish Aravamudan wrote:
> On 3/27/08, Gurudas Pai <gurudas.pai@oracle.com> wrote:
>>
>>  Ingo Molnar wrote:
>>  > * Gurudas Pai <gurudas.pai@oracle.com> wrote:
>>  >
>>  >> Hi,
>>  >>
>>  >> On 2.6.25-rc7 allocate hugepages and run a fio test with following
>>  >> jobfile,
>>  >
>>  > could you try x86.git/latest:
>>  >
>>  >   http://people.redhat.com/mingo/x86.git/README
>>  >
>>  > it has a fix that could fix such a leak.
>>  >
>>  >       Ingo
>>
>>
>> Applied latest two patches and re-ran the test,
>>
>>  hugetlb: fix potential livelock in return_unused_surplus_hugepages()
>>  hugetlb: indicate surplus huge page counts in per-node meminfo
>>
>>  Still same result,
> 
> Ingo was referring to the x86.git tree, not linus.git (to which those
> two patches have been applied). I'm not sure if there is something
> x86.git that hasn't been pushed to LInus yet?
> 
>>  >cat /proc/meminfo | grep Huge
>>  HugePages_Total:  1000
>>
>> HugePages_Free:    551
>>
>> HugePages_Rsvd:      1
>>  HugePages_Surp:      0
>>  Hugepagesize:     2048 kB
>>
>>  >echo 0 > /proc/sys/vm/nr_hugepages
>>  >cat /proc/meminfo | grep Huge
>>
>> HugePages_Total:   450
>>  HugePages_Free:      1
>>  HugePages_Rsvd:      1
>>  HugePages_Surp:    450
>>  Hugepagesize:     2048 kB
> 
> Hrm, fio is using SHM_HUGETLB. Does ipcs indicate maybe fio is not
> cleaning up the shared memory segment? 
Indeed , since fio crashed during the run there were shared memory segment 
allocated. Just removed them and 
HugePages_Total:  1000
HugePages_Free:   1000
HugePages_Rsvd:      0
HugePages_Surp:      0
Hugepagesize:     2048 kB

So not a bug. Thank you all for your time and effort.

Regards,
-Guru
