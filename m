Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbXLEUwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbXLEUwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 15:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbXLEUwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 15:52:24 -0500
Received: from ccs17.jlab.org ([129.57.35.82]:46273 "EHLO ccs17.jlab.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbXLEUwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 15:52:23 -0500
Message-ID: <47570F83.6040601@jlab.org>
Date: Wed, 05 Dec 2007 15:52:19 -0500
From: Jie Chen <chen@jlab.org>
Organization: Jefferson Lab
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Simon Holm Th??gersen <odie@cs.aau.dk>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Possible bug from kernel 2.6.22 and above, 2.6.24-rc4
References: <1195698770.11808.4.camel@odie.local> <4744F042.4070002@jlab.org> <20071204131707.GA4232@elte.hu> <4756C3D9.9030107@jlab.org> <20071205154014.GA6491@elte.hu> <4756D058.1070500@jlab.org> <20071205164723.GA25641@elte.hu> <4756E44E.8080607@jlab.org> <20071205200343.GA14570@elte.hu> <475708A7.4030708@jlab.org> <20071205204645.GC25694@elte.hu>
In-Reply-To: <20071205204645.GC25694@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jie Chen <chen@jlab.org> wrote:
> 
>> I just disabled the affinity mask and reran the test. There were no 
>> significant changes for two threads (barrier overhead is around 9 
>> microseconds). As for 8 threads, the barrier overhead actually drops a 
>> little, which is good. Let me know whether I can be any help. Thank 
>> you very much.
> 
> sorry to be dense, but could you give me instructions how i could remove 
> the affinity mask and test the "barrier overhead" myself? I have built 
> "pthread_sync" and it outputs numbers for me - which one would be the 
> barrier overhead: Reference_time_1 ?
> 
> 	Ingo
Hi, Ingo:

To disable affinity, do configure --enable-public-release 
--disable-thread_affinity. You should see barrier overhead like the 
following:
Computing BARRIER time

Sample_size  Average     Min    Max          S.D.        Outliers
  20      19.486162   19.482250   19.491400    0.002740      0

BARRIER time =        19.486162 microseconds +/- 0.005371
BARRIER overhead =    8.996257 microseconds +/- 0.006575

The Reference_time_1 is the elapsed time for single thread doing simple 
loop without any synchronization. Thank you.

-- 
###############################################
Jie Chen
Scientific Computing Group
Thomas Jefferson National Accelerator Facility
12000, Jefferson Ave.
Newport News, VA 23606

(757)269-5046 (office) (757)269-6248 (fax)
chen@jlab.org
###############################################

