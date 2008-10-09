Return-Path: <linux-kernel-owner+w=401wt.eu-S1757063AbYJIH3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbYJIH3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 03:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755626AbYJIH3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 03:29:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62145 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755487AbYJIH3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 03:29:38 -0400
Message-ID: <48EDB22D.6050908@cn.fujitsu.com>
Date: Thu, 09 Oct 2008 15:26:37 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Andi Kleen <andi@firstfloor.org>, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, rjw@sisk.pl,
       dipankar@in.ibm.com, tglx@linuxtronix.de
Subject: Re: [PATCH] rudimentary tracing for Classic RCU
References: <20081009065529.GC24560@one.firstfloor.org> <48EDAD55.2000502@cn.fujitsu.com> <20081009161232.DEDC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20081009161232.DEDC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Hi Lai-san,
> 
>>>> In this case, why not define it as:
>>>> static char buf[20*NR_CPUS + 100];
>>> Actually you should near never use NR_CPUS now but always num_possible_cpus()
>>> (or even num_online_cpus()) Using NR_CPUS can lead to extreme waste
>>> of memory on kernels which are compiled for 4096 CPUs for example.
>>>
>>> And with num_possible_cpus() kmalloc is needed.
>> I thought the default value of NR_CPUS is 32.
> 
> it's pointless.
> Almost distribution use _very_ large NR_CPUS (likes 4096).
> So, We should concern large NR_CPUS.

Thanks.

So my advice is to use seq_file.

> 
> 
>> if NR_CPUS is too large, I think using seq_file is good idea,
>> and rcuclassic_trace_mutex is not need too.
> 
> 
> 
> 
> 


