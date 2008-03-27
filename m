Return-Path: <linux-kernel-owner+w=401wt.eu-S1758819AbYC0K01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819AbYC0K01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 06:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbYC0K0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 06:26:19 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:45244 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbYC0K0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 06:26:19 -0400
Message-ID: <47EB75C5.20207@oracle.com>
Date: Thu, 27 Mar 2008 15:54:05 +0530
From: Gurudas Pai <gurudas.pai@oracle.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG]:2.6.25-rc7 memory leak with hugepages.
References: <47EB4E2A.1040507@oracle.com> <20080327083849.GF15626@elte.hu>
In-Reply-To: <20080327083849.GF15626@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
> * Gurudas Pai <gurudas.pai@oracle.com> wrote:
> 
>> Hi,
>>
>> On 2.6.25-rc7 allocate hugepages and run a fio test with following 
>> jobfile,
> 
> could you try x86.git/latest:
> 
>   http://people.redhat.com/mingo/x86.git/README
> 
> it has a fix that could fix such a leak.
> 
> 	Ingo

Applied latest two patches and re-ran the test,

hugetlb: fix potential livelock in return_unused_surplus_hugepages()
hugetlb: indicate surplus huge page counts in per-node meminfo

Still same result,

>cat /proc/meminfo | grep Huge
HugePages_Total:  1000
HugePages_Free:    551
HugePages_Rsvd:      1
HugePages_Surp:      0
Hugepagesize:     2048 kB

>echo 0 > /proc/sys/vm/nr_hugepages
>cat /proc/meminfo | grep Huge
HugePages_Total:   450
HugePages_Free:      1
HugePages_Rsvd:      1
HugePages_Surp:    450
Hugepagesize:     2048 kB



Thanks,
-Guru
