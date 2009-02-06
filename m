Return-Path: <linux-kernel-owner+w=401wt.eu-S1758585AbZBFDLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585AbZBFDLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 22:11:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758437AbZBFDLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 22:11:03 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57680 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758418AbZBFDLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 22:11:02 -0500
Message-ID: <498BAA22.50709@cn.fujitsu.com>
Date: Fri, 06 Feb 2009 11:10:26 +0800
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
References: <20090203172135.GF918@balbir.in.ibm.com> <498BA857.3080809@cn.fujitsu.com>
In-Reply-To: <498BA857.3080809@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
>> +	mem_cgrp = memcg->css.cgroup;
>> +	task_cgrp = mem_cgroup_from_task(p)->css.cgroup;
> 
> I just noticed since v2, task's cgroup is also printed. Then 2 issues here:
> 
> 1. this is better: task_cgrp = task_subsys_state(p, mem_cgroup_subsys_id);

sorry, s/task_subsys_state/task_cgroup/

> 2. getting cgroup from a task should be protected by task_lock or rcu_read_lock,
>    so we can put the above statement inside rcu_read_lock below.
