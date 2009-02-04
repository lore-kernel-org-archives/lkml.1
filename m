Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbZBDBgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbZBDBgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 20:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751046AbZBDBgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 20:36:14 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54207 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbZBDBgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 20:36:13 -0500
Message-ID: <4988F0E4.3010404@cn.fujitsu.com>
Date: Wed, 04 Feb 2009 09:35:32 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [-mm patch] Show memcg information during OOM (v3)
References: <20090203172135.GF918@balbir.in.ibm.com> <4988E727.8030807@cn.fujitsu.com>
In-Reply-To: <4988E727.8030807@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
>> +{
>> +	struct cgroup *task_cgrp;
>> +	struct cgroup *mem_cgrp;
>> +	/*
>> +	 * Need a buffer on stack, can't rely on allocations. The code relies
> 
> I think it's in .bss section, but not on stack

> and it's better to explain why
> the static buffer is safe in the comment.
> 

Sorry, I just saw the below comment.

>> +	 * on the assumption that OOM is serialized for memory controller.
>> +	 * If this assumption is broken, revisit this code.
>> +	 */
>> +	static char task_memcg_name[PATH_MAX];
>> +	static char memcg_name[PATH_MAX];
>> +	int ret;
> 
