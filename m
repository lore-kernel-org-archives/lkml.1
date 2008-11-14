Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbYKNDzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbYKNDzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 22:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYKNDzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 22:55:09 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51933 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbYKNDzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 22:55:08 -0500
Message-ID: <491CF609.3050203@cn.fujitsu.com>
Date: Fri, 14 Nov 2008 11:52:41 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Blunck <jblunck@suse.de>, containers@lists.osdl.org,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] Dynamically allocate struct mem_cgroup_stat_cpu memory
References: <20081113164201.GV29067@bolzano.suse.de> <20081113191837.18ed2ade.akpm@linux-foundation.org>
In-Reply-To: <20081113191837.18ed2ade.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>

Andrew Morton wrote:
> (cc containers@lists.osdl.org)
> 
> On Thu, 13 Nov 2008 17:42:01 +0100 Jan Blunck <jblunck@suse.de> wrote:
> 
>> When increasing NR_CPUS to 4096 the size of struct mem_cgroup is growing to
>> 507904 bytes per instance on x86_64. This patch changes the allocation of
>> struct mem_cgroup_stat_cpu to be based on the number of configured CPUs during
>> boot time. The init_mem_cgroup still is that huge since it stays statically
>> allocated and therefore uses the compile-time maximum.
>>

I think you can just remove init_mem_cgroup, because memcg doesn't require
early initialization (when kmalloc is not avaiable), and I found init_mem_cgroup
is not treated specially after greping 'init_mem_cgroup' in the code.


