Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbYDCKP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbYDCKP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 06:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbYDCKPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 06:15:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60065 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbYDCKPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 06:15:17 -0400
Message-ID: <47F4ADB9.5040606@cn.fujitsu.com>
Date: Thu, 03 Apr 2008 18:13:13 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 1/3] cgroup: use a hash table for css_set finding
References: <47F470AB.2070904@cn.fujitsu.com> <20080403162459.4a90d574.kamezawa.hiroyu@jp.fujitsu.com> <47F48C69.2080805@cn.fujitsu.com>
In-Reply-To: <47F48C69.2080805@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> +static struct hlist_head *css_set_hash(struct cgroup_subsys_state *css[])
>>> +{
>>> +	int i;
>>> +	int index;
>>> +	unsigned long tmp = 0UL;
>>> +
>>> +	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++)
>>> +		tmp += (unsigned long)css[i];
>>> +
>> maybe css[i]'s lower 2-3 bits will be ignored. because thery are always 0.
>>
>> And I don't like "+" for hash. how about
>> ==
>> 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++)
>> 	unsigned long x;
>> 	x = (unsigned long)css[i];
>> 	tmp = (x >> 16) ^ (x & 0xffff)
>> ==
>> or some func, which uses full bits.
>>
> 
> I'm using hash_long(), which has been proved to be a good one. And I've tested
> css_set_hash(), I run the css_set benchmark with N == 1000, the for loop in
> find_existing_css_set() will break out within 10 iterations for most cases, 
> which is the expected result.
> 

I just revised the css_set_hash() a bit, and It turned out we can improve the
scalability.

Thanks, KAMEZAWA-san.
