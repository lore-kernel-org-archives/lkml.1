Return-Path: <linux-kernel-owner+w=401wt.eu-S1752250AbYJVBnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250AbYJVBnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 21:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbYJVBms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 21:42:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52530 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbYJVBmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 21:42:47 -0400
Message-ID: <48FE8511.1090903@cn.fujitsu.com>
Date: Wed, 22 Oct 2008 09:42:41 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH][BUGFIX] memcg: fix page_cgroup allocation
References: <20081022102404.e1f3565a.kamezawa.hiroyu@jp.fujitsu.com> <20081021183738.d3c995b9.akpm@linux-foundation.org>
In-Reply-To: <20081021183738.d3c995b9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> --- linux-2.6.orig/mm/page_cgroup.c
>> +++ linux-2.6/mm/page_cgroup.c
>> @@ -4,7 +4,12 @@
>>  #include <linux/bit_spinlock.h>
>>  #include <linux/page_cgroup.h>
>>  #include <linux/hash.h>
>> +#include <linux/slab.h>
>>  #include <linux/memory.h>
>> +#include <linux/cgroup.h>
>> +
>> +extern struct cgroup_subsys	mem_cgroup_subsys;
> 
> no no bad! evil! unclean!
> 
> Didn't the linux/cgroup.h -> linux/cgroup_subsys..h inclusion already
> declare this for us?
> 

Yes, I think just include <linux/cgroup.h> is enough.

#define SUBSYS(_x) extern struct cgroup_subsys _x ## _subsys;
#include <linux/cgroup_subsys.h>
#undef SUBSYS

and will be expanded to:

extern struct cgroup_subsys cpu_subsys;
extern struct cgroup_subsys cpuset_subsys;
extern struct cgroup_subsys memory_cgroup_subsys;
...

