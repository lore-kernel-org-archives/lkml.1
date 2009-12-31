Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbZLaQcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbZLaQcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 11:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbZLaQck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 11:32:40 -0500
Received: from mail.tmr.com ([64.65.253.246]:55796 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbZLaQcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 11:32:39 -0500
Message-ID: <4B3CD221.1090402@tmr.com>
Date: Thu, 31 Dec 2009 11:32:33 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 NOT Firefox/3.0.11 pango-text SeaMonkey/1.1.16
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ubuntu 32-bit, 32-bit PAE, 64-bit Kernel Benchmarks
References: <SNT125-W41CEF6892DBE0B1FD99B4AC3780@phx.gbl> <4B3C1137.8060308@tmr.com> <4B3C5F22.1080108@panasas.com>
In-Reply-To: <4B3C5F22.1080108@panasas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> On 12/31/2009 04:49 AM, Bill Davidsen wrote:
>> Yuhong Bao wrote:
>>> Given that Linus was once talking about the performance penalties of PAE and HIGHMEM64G, perhaps you'd find these benchmarks done by Phoronix of interest:
>>> http://www.phoronix.com/scan.php?page=article&item=ubuntu_32_pae
>>>
>> I find these tests mirror my own experience with PAE, the benefit of having the 
>> nx hardware enabled justifies the few percent drop in performance I was able to 
>> find.
>>
>> I find the huge gain in web service hard to believe without a hint why a 64 bit 
>> CPU would be 15x faster. The disk, memory, and network wouldn't be faster, and 
>> the CPU intensive tests weren't significantly faster, so unless the systems were 
>> tuned differently where's the gain? Same feeling about the TP test, an order of 
>> magnitude faster on a test running the same application on the same hardware is 
>> hard to buy without an explanation.
>>
> 
> Why? simple, Memory. This system must have lots of memory (see the HIGHMEM64G) so
> lots of IO must be bouncing on a 32bit system, where in 64bit it is copy-less.
> 
Did you miss the hardware configuration? It was run on a laptop with 4GB and two 
little laptop drives. And there was no serious difference between the non-PAE 
(sees 3GB) and PAE (sees 4GB) performance. Clearly there's little enough memory 
to address in any mode.

> Just my guess, but I'm not surprised.
> 
Eight thousand pages/sec out of a laptop with 5400 rpm drives doesn't surprise 
you? Even if every page were copied to somewhere else the speed of the disk and 
network are still 1000 times slower. I haven't found details on this "test" but 
I'm guessing that the pages are all in memory so the disk is only used once, 
maybe even the same page being read each time, and if the client is on the same 
machine the "network" is loopback. Not representative of much of anything in the 
general case, that.

>> The only obvious source I can think of is running the test load at 100Mbit on
>> one test and Gbit on another, because I saw an early network driver do just that
>> in negotiations with a switch.
>>


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
