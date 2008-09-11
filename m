Return-Path: <linux-kernel-owner+w=401wt.eu-S1755077AbYIKM6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbYIKM6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 08:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbYIKM6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 08:58:23 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59137 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbYIKM6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 08:58:23 -0400
From: kamezawa.hiroyu@jp.fujitsu.com
Message-ID: <29991128.1221137393330.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 11 Sep 2008 21:49:53 +0900 (JST)
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: Re: [RFC] [PATCH 9/9] memcg: percpu page cgroup lookup cache
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       balbir@linux.vnet.ibm.com, xemul@openvz.org, hugh@veritas.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, menage@google.com
In-Reply-To: <200809112131.34414.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <200809112131.34414.nickpiggin@yahoo.com.au>
 <20080911200855.94d33d3b.kamezawa.hiroyu@jp.fujitsu.com> <20080911202407.752b5731.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
>On Thursday 11 September 2008 21:24, KAMEZAWA Hiroyuki wrote:
>> Use per-cpu cache for fast access to page_cgroup.
>> This patch is for making fastpath faster.
>>
>> Because page_cgroup is accessed when the page is allocated/freed,
>> we can assume several of continuous page_cgroup will be accessed soon.
>> (If not interleaved on NUMA...but in such case, alloc/free itself is slow.)
>>
>> We cache some set of page_cgroup's base pointer on per-cpu area and
>> use it when we hit.
>>
>> TODO:
>>  - memory/cpu hotplug support.
>
>How much does this help?
>
1-2% in unixbench's test (in 0/9) on 2core/1socket x86-64/SMP host.
(cpu is not the newest one.)
This per-cpu covers 32 * 128MB=4GB of area.
Using 256 bytes(32 entry) is over-kill ?

Thanks,
-Kame
