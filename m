Return-Path: <linux-kernel-owner+w=401wt.eu-S1762780AbYDODPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762780AbYDODPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 23:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764257AbYDODPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 23:15:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54409 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1761937AbYDODP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 23:15:29 -0400
Message-ID: <48041D90.2040702@cn.fujitsu.com>
Date: Tue, 15 Apr 2008 11:14:24 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>, menage@google.com,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] use vmalloc for mem_cgroup allocation. v2
References: <20080415105434.3044afb6.kamezawa.hiroyu@jp.fujitsu.com>	<20080415111038.ffac0e12.kamezawa.hiroyu@jp.fujitsu.com>	<20080414191730.7d13e619.akpm@linux-foundation.org> <20080415121617.16127623.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080415121617.16127623.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Mon, 14 Apr 2008 19:17:30 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
>> Well...  vmalloced memory is of course a little slower to use - additional
>> TLB pressure.
>>
>> Do you think the memcgroup is accessed frequently enough to use vmalloc()
>> only on those architectures which actually need it?
>>
>> Because it'd be pretty simple to implement:
>>
>> 	if (sizeof(struct mem_group) > PAGE_SIZE)
>> 		vmalloc()
>> 	else
>> 		kmalloc()
>>
>> 	...
>>
>> 	if (sizeof(struct mem_group) > PAGE_SIZE)
>> 		vfree()
>> 	else
>> 		kfree()
>>
>> the compiler will optimise away the `if'.
>>
> 
> Hmm, ok. I'll rewrite one to do that.
> 

It will be better to use wrappers for these: mem_cgroup_alloc() and mem_cgroup_free()

> Thanks,
> -Kame
> 
> 
> 
