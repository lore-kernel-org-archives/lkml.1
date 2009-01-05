Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbZAEHP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbZAEHP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 02:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbZAEHPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 02:15:50 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:49770 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbZAEHPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 02:15:49 -0500
Message-ID: <4961B3A1.3070009@colorfullife.com>
Date: Mon, 05 Jan 2009 08:15:45 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [RFC, PATCH] kernel/rcu: add kfree_rcu
References: <200901021159.n02BxDLg024728@mail.q-ag.de> <20090102185543.GE6842@linux.vnet.ibm.com> <49604E19.8040502@cn.fujitsu.com> <20090104194851.GM6958@linux.vnet.ibm.com>
In-Reply-To: <20090104194851.GM6958@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
>
>> I think these two are different questions.
>> vfree() still can not be called from softirq context now.
>> And I proposed vfree_atomic() for RCU, but it can not be accepted.
>>     
>
> And one would indeed either need to have a vfree_atomic() or have some
> mechanism that sent the vfree() to a workqueue or some such.
>   
ipc/util.c uses a workqueue (ipc_schedule_free):
The semaphore array structure can be large (documented with SEMMSL=8000 
around 16 kB, but there is no  hard limit), thus vmalloc is used.

But as long as there are just one or two users, I doubt that a generic 
system is worth the effort.

--
    Manfred

