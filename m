Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbXLKQj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbXLKQj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 11:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbXLKQjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 11:39:17 -0500
Received: from ccs17.jlab.org ([129.57.35.82]:63981 "EHLO ccs17.jlab.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbXLKQjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 11:39:16 -0500
Message-ID: <475EBD30.1010506@jlab.org>
Date: Tue, 11 Dec 2007 11:39:12 -0500
From: Jie Chen <chen@jlab.org>
Organization: Jefferson Lab
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Possible bug from kernel 2.6.22 and above, 2.6.24-rc4
References: <20071205204645.GC25694@elte.hu> <47570F83.6040601@jlab.org> <20071205210222.GA30089@elte.hu> <47572353.4040606@jlab.org> <20071206104318.GB30838@elte.hu> <47582367.6060602@jlab.org> <20071210105943.GA5370@elte.hu> <475D9BB5.20808@jlab.org> <20071211105149.GA24250@elte.hu> <475EAC81.1020408@jlab.org> <20071211155226.GA1056@elte.hu>
In-Reply-To: <20071211155226.GA1056@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jie Chen <chen@jlab.org> wrote:
> 
>> Hi, Ingo:
>>
>> I guess it is a good news. I did patch 2.6.21.7 kernel using your cfs 
>> patch. The results of pthread_sync is the same as the non-patched 
>> 2.6.21 kernel. This means the performance of is not related to the 
>> scheduler. As for overhead of the gettimeofday, there is no difference 
>> between 2.6.21 and 2.6.24-rc4. The reference time is around 10.5 us 
>> for both kernel.
> 
> could you please paste again the relevant portion of the output you get 
> on a "good" .21 kernel versus the output you get on a "bad" .24 kernel?
> 
>> So what is changed between 2.6.21 and 2.6.22? Any hints :-). Thank you 
>> very much for all your help.
> 
> we'll figure it out i'm sure :)
> 
> 	Ingo

Hi, Ingo:

The following is pthread_sync output for 2.6.21.7-cfs-v24 #1 SMP kernel.

2 threads:

Computing reference time 1

Sample_size       Average     Min     Max    S.D.       Outliers
  20     10.489085   10.488800   10.491100    0.000539      1

Reference_time_1 =  10.489085 microseconds +/- 0.001057

Computing PARALLEL time

Sample_size       Average     Min     Max  S.D.          Outliers
  20     11.106580   11.105650   11.109700    0.001255      0

PARALLEL time =       11.106580 microseconds +/- 0.002460
PARALLEL overhead =    0.617590 microseconds +/- 0.003409

8 threads:
Computing reference time 1

Sample_size       Average     Min    Max     S.D.          Outliers
  20        10.488735   10.488500   10.490700    0.000484      1

Reference_time_1 =     10.488735 microseconds +/- 0.000948

Computing PARALLEL time

Sample_size       Average     Min    Max     S.D.          Outliers
  20       13.000647   12.991050   13.052700    0.012592      1

PARALLEL time =        13.000647 microseconds +/- 0.024680
PARALLEL overhead =     2.511907 microseconds +/- 0.025594


Output for Kernel 2.6.24-rc4 #1 SMP

2 threads:
Computing reference time 1

Sample_size       Average     Min     Max    S.D.          Outliers
  20          10.510535   10.508600   10.518200    0.002237      1

Reference_time_1 =           10.510535 microseconds +/- 0.004384

Computing PARALLEL time

Sample_size       Average     Min    Max     S.D.          Outliers
  20         19.668450   19.650200   19.679650    0.008052      0

PARALLEL time =              19.668450 microseconds +/- 0.015782
PARALLEL overhead =           9.157945 microseconds +/- 0.018217

8 threads:
Computing reference time 1

Sample_size       Average     Min    Max    S.D.          Outliers
  20        10.491285   10.490100   10.494900    0.001085      1

Reference_time_1 =           10.491285 microseconds +/- 0.002127

Computing PARALLEL time

Sample_size       Average     Min    Max    S.D.          Outliers
  20        13.090080   13.079150   13.131450    0.010995      1

PARALLEL time =              13.090080 microseconds +/- 0.021550
PARALLEL overhead =          2.598590 microseconds +/- 0.024534

For 8 threads, both kernels have the similar performance number. But for 
2 threads, the 2.6.21 is much better than 2.6.24-rc4. Thank you.


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

