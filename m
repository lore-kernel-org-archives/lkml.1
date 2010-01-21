Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313Ab0AUPai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab0AUPai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 10:30:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592Ab0AUPai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 10:30:38 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:57011 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab0AUPah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 10:30:37 -0500
Message-ID: <4B587317.6060404@linux.vnet.ibm.com>
Date: Thu, 21 Jan 2010 21:00:31 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0b1 Thunderbird/3.0
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       kirill@shutemov.name
Subject: Re: [PATCH mmotm] memcg use generic percpu allocator instead of private
 one
References: <20100120161825.15c372ac.kamezawa.hiroyu@jp.fujitsu.com> <4B56CEF0.2040406@linux.vnet.ibm.com> <20100121110759.250ed739.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100121110759.250ed739.kamezawa.hiroyu@jp.fujitsu.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 January 2010 07:37 AM, KAMEZAWA Hiroyuki wrote:
> On Wed, 20 Jan 2010 15:07:52 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>>> This includes no functional changes.
>>>
>>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>
>>
>> Before review, could you please post parallel pagefault data on a large
>> system, since root now uses these per cpu counters and its overhead is
>> now dependent on these counters. Also the data read from root cgroup is
>> also dependent on these, could you make sure that is not broken.
>>
> Hmm, I rewrote test program for avoidng mmap_sem. This version does fork()
> instead of pthread_create() and meausre parallel-process page fault speed.
> 
> [Before patch]
> [root@bluextal memory]# /root/bin/perf stat -e page-faults,cache-misses --repeat 5 ./multi-fault-fork 8
> 
>  Performance counter stats for './multi-fault-fork 8' (5 runs):
> 
>        45256919  page-faults                ( +-   0.851% )
>       602230144  cache-misses               ( +-   0.187% )
> 
>    61.020533723  seconds time elapsed   ( +-   0.002% 
> 
> [After patch]
> [root@bluextal memory]# /root/bin/perf stat -e page-faults,cache-misses --repeat 5 ./multi-fault-fork 8
> 
>  Performance counter stats for './multi-fault-fork 8' (5 runs):
> 
>        46007166  page-faults                ( +-   0.339% )
>       599553505  cache-misses               ( +-   0.298% )
> 
>    61.020937843  seconds time elapsed   ( +-   0.004% )
> 
> slightly improved ? But this test program does some extreme behavior and
> you can't see difference in real-world applications, I think.
> So, I guess this is in error-range in famous (not small) benchmarks.

Looks good, please give me a couple of days to test, I'll revert back
with numbers and review.

-- 
Three Cheers,
Balbir Singh
