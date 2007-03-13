Return-Path: <linux-kernel-owner+w=401wt.eu-S1753137AbXCMGBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbXCMGBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 02:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbXCMGBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 02:01:04 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:36202 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbXCMGBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 02:01:01 -0400
Message-ID: <45F63DFB.9040302@cosmosbay.com>
Date: Tue, 13 Mar 2007 07:00:27 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Anton Blanchard <anton@samba.org>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Rik van Riel <riel@redhat.com>,
       Lorenzo Allegrucci <l_allegrucci@yahoo.it>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: SMP performance degradation with sysbench
References: <1172425476.5489.11.camel@odyssey.lan> <45E21FEC.9060605@redhat.com> <45E2E244.8040009@yahoo.com.au> <20070312220042.GA807@kryten>
In-Reply-To: <20070312220042.GA807@kryten>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Tue, 13 Mar 2007 07:00:26 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Blanchard a écrit :
>  
> Hi Nick,
> 
>> Anyway, I'll keep experimenting. If anyone from MySQL wants to help look
>> at this, send me a mail (eg. especially with the sched_setscheduler issue,
>> you might be able to do something better).
> 
> I took a look at this today and figured Id document it:
> 
> http://ozlabs.org/~anton/linux/sysbench/
> 
> Bottom line: it looks like issues in the glibc malloc library, replacing
> it with the google malloc library fixes the negative scaling:
> 
> # apt-get install libgoogle-perftools0
> # LD_PRELOAD=/usr/lib/libtcmalloc.so /usr/sbin/mysqld

Hi Anton, thanks for the report.
glibc has certainly many scalability problems.

One of the known problem is its (ab)use of mmap() to allocate one (yes : one 
!) page every time you fopen() a file. And then a munmap() at fclose() time.


mmap()/munmap() should be avoided as hell in multithreaded programs.
