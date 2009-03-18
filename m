Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbZCRHZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbZCRHZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 03:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbZCRHZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 03:25:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57549 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbZCRHZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 03:25:14 -0400
Message-ID: <49C0A171.8060009@cn.fujitsu.com>
Date: Wed, 18 Mar 2009 15:23:29 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Dhaval Giani <dhaval@linux.vnet.ibm.com>, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com,
       ryov@valinux.co.jp, fernando@intellilink.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, arozansk@redhat.com, jmoyer@redhat.com,
       oz-kernel@redhat.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, menage@google.com, peterz@infradead.org
Subject: Re: [PATCH 01/10] Documentation
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com> <1236823015-4183-2-git-send-email-vgoyal@redhat.com> <20090312100054.GA8024@linux.vnet.ibm.com> <20090312140450.GE10919@redhat.com>
In-Reply-To: <20090312140450.GE10919@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
>> Hi Vivek,
>>
>> I would be interested in knowing if these are the results expected?
>>
> 
> Hi Dhaval, 
> 
> Good question. Keeping current expectation in mind, yes these are expected
> results. To begin with, current expectations are that try to emulate
> cfq behavior and the kind of service differentiation we get between
> threads of different priority, same kind of service differentiation we
> should get from different cgroups.
>  
> Having said that, in theory a more accurate estimate should be amount 
> of actual disk time a queue/cgroup got. I have put a tracing message
> to keep track of total service received by a queue. If you run "blktrace"
> then you can see that. Ideally, total service received by two threads
> over a period of time should be in same proportion as their cgroup
> weights.
> 
> It will not be easy to achive it given the constraints we have got in
> terms of how to accurately we can account for disk time actually used by a
> queue in certain situations. So to begin with I am targetting that
> try to meet same kind of service differentation between cgroups as
> cfq provides between threads and then slowly refine it to see how
> close one can come to get accurate numbers in terms of "total_serivce"
> received by each queue.

  Hi Vivek,

  I simply tested with blktrace opened. I create two groups and set ioprio
  4 and 7 respectively(the corresponding weight should 4:1, right?), and 
  start two dd concurrently. UUIC, Ideally, the proportion of service two 
  dd got should be 4:1 in a period of time when they are running. I extract 
  *served* value from blktrace output and sum them up. I found the proportion 
  of the sum of *served* value is about 1.7:1
  Am i missing something?

  I extract the following highlight value
  8,0  0   0   18.914906549     0  m   N 6601ioq served=*0x13* total service=0x184d

> 
> Thanks
> Vivek
> 
> 
> 

-- 
Regards
Gui Jianfeng

