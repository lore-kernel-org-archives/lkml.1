Return-Path: <linux-kernel-owner+w=401wt.eu-S939888AbXG3VIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939888AbXG3VIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 17:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939307AbXG3VID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 17:08:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937995AbXG3VIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 17:08:02 -0400
Message-ID: <46AE5322.9030605@redhat.com>
Date: Mon, 30 Jul 2007 17:07:46 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: tim.c.chen@linux.intel.com
CC: Andrea Arcangeli <andrea@suse.de>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: pluggable scheduler thread (was Re: Volanomark slows by 80%	under
 CFS)
References: <1185573687.19777.44.camel@localhost.localdomain>	 <46AA8E57.8010105@redhat.com> <20070728005920.GA31622@v2.random>	 <46AABB5B.3030702@redhat.com> <20070728050141.GC31622@v2.random>	 <46AAE760.9030602@redhat.com> <1185821379.19777.58.camel@localhost.localdomain>
In-Reply-To: <1185821379.19777.58.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Chen wrote:
> On Sat, 2007-07-28 at 02:51 -0400, Chris Snook wrote:
> 
>> Tim --
>>
>> 	Since you're already set up to do this benchmarking, would you mind 
>> varying the parameters a bit and collecting vmstat data?  If you want to 
>> run oprofile too, that wouldn't hurt.
>>
> 
> Here's the vmstat data.  The number of runnable processes are 
> fewer and there're more contex switches with CFS. 
>  
> The vmstat for 2.6.22 looks like
> 
> procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu------
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
> 391  0      0 1722564  14416  95472    0    0   169    25   76 6520  3  3 89  5  0
> 400  0      0 1722372  14416  95496    0    0     0     0  264 641685 47 53  0  0  0
> 368  0      0 1721504  14424  95496    0    0     0     7  261 648493 46 51  3  0  0
> 438  0      0 1721504  14432  95496    0    0     0     2  264 690834 46 54  0  0  0
> 400  0      0 1721380  14432  95496    0    0     0     0  260 657157 46 53  1  0  0
> 393  0      0 1719892  14440  95496    0    0     0     6  265 671599 45 53  2  0  0
> 423  0      0 1719892  14440  95496    0    0     0    15  264 701626 44 56  0  0  0
> 375  0      0 1720240  14472  95504    0    0     0    72  265 671795 43 53  3  0  0
> 393  0      0 1720140  14480  95504    0    0     0     7  265 733561 45 55  0  0  0
> 355  0      0 1716052  14480  95504    0    0     0     0  260 670676 43 54  3  0  0
> 419  0      0 1718900  14480  95504    0    0     0     4  265 680690 43 55  2  0  0
> 396  0      0 1719148  14488  95504    0    0     0     3  261 712307 43 56  0  0  0
> 395  0      0 1719148  14488  95504    0    0     0     2  264 692781 44 54  1  0  0
> 387  0      0 1719148  14492  95504    0    0     0    41  268 709579 43 57  0  0  0
> 420  0      0 1719148  14500  95504    0    0     0     3  265 690862 44 54  2  0  0
> 429  0      0 1719396  14500  95504    0    0     0     0  260 704872 46 54  0  0  0
> 460  0      0 1719396  14500  95504    0    0     0     0  264 716272 46 54  0  0  0
> 419  0      0 1719396  14508  95504    0    0     0     3  261 685864 43 55  2  0  0
> 455  0      0 1719396  14508  95504    0    0     0     0  264 703718 44 56  0  0  0
> 395  0      0 1719372  14540  95512    0    0     0    64  265 692785 45 54  1  0  0
> 424  0      0 1719396  14548  95512    0    0     0    10  265 732866 45 55  0  0  0
> 
> While 2.6.23-rc1 look like
> procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu------
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
> 23  0      0 1705992  17020  95720    0    0     0     0  261 1010016 53 42  5  0  0
>  7  0      0 1706116  17020  95720    0    0     0    13  267 1060997 52 41  7  0  0
>  5  0      0 1706116  17020  95720    0    0     0    28  266 1313361 56 41  3  0  0
> 19  0      0 1706116  17028  95720    0    0     0     8  265 1273669 55 41  4  0  0
> 18  0      0 1706116  17032  95720    0    0     0     2  262 1403588 55 41  4  0  0
> 23  0      0 1706116  17032  95720    0    0     0     0  264 1272561 56 40  4  0  0
> 14  0      0 1706116  17032  95720    0    0     0     0  262 1046795 55 40  5  0  0
> 16  0      0 1706116  17032  95720    0    0     0     0  260 1361102 58 39  4  0  0
>  4  0      0 1706224  17120  95724    0    0     0   126  273 1488711 56 41  3  0  0
> 24  0      0 1706224  17128  95724    0    0     0     6  261 1408432 55 41  4  0  0
>  3  0      0 1706240  17128  95724    0    0     0    48  273 1299203 54 42  4  0  0
> 16  0      0 1706240  17132  95724    0    0     0     3  261 1356609 54 42  4  0  0
>  5  0      0 1706364  17132  95724    0    0     0     0  264 1293198 58 39  3  0  0
>  9  0      0 1706364  17132  95724    0    0     0     0  261 1555153 56 41  3  0  0
> 13  0      0 1706364  17132  95724    0    0     0     0  264 1160296 56 40  4  0  0
>  8  0      0 1706364  17132  95724    0    0     0     0  261 1388909 58 38  4  0  0
> 18  0      0 1706364  17132  95724    0    0     0     0  264 1236774 56 39  5  0  0
> 11  0      0 1706364  17136  95724    0    0     0     2  261 1360325 57 40  3  0  0
>  5  0      0 1706364  17136  95724    0    0     0     1  265 1201912 57 40  3  0  0
>  8  0      0 1706364  17136  95724    0    0     0     0  261 1104308 57 39  4  0  0
>  7  0      0 1705976  17232  95724    0    0     0   127  274 1205212 58 39  4  0  0
> 
> Tim
> 

 From a scheduler performance perspective, it looks like CFS is doing much 
better on this workload.  It's spending a lot less time in %sys despite the 
higher context switches, and there are far fewer tasks waiting for CPU time. 
The real problem seems to be that volanomark is optimized for a particular 
scheduler behavior.

That's not to say that we can't improve volanomark performance under CFS, but 
simply that CFS isn't so fundamentally flawed that this is impossible.

When I initially agreed with zeroing out wait time in sched_yield, I didn't 
realize that it could be negative and that this would actually promote processes 
in some cases.  I still think it's reasonable to zero out positive wait times. 
Can you test to see if that optimization does better than unconditionally 
zeroing them out?

	-- Chris
