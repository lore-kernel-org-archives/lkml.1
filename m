Return-Path: <linux-kernel-owner+w=401wt.eu-S1753261AbYC1Ko3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbYC1Ko3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 06:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYC1KoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 06:44:23 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46270 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbYC1KoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 06:44:22 -0400
Date: Fri, 28 Mar 2008 19:48:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>, Pavel Emelianov <xemul@openvz.org>,
       Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [-mm] Add an owner to the mm_struct (v2)
Message-Id: <20080328194839.fe6ffa52.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080328082316.6961.29044.sendpatchset@localhost.localdomain>
References: <20080328082316.6961.29044.sendpatchset@localhost.localdomain>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2008 13:53:16 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> 
> 
> This patch removes the mem_cgroup member from mm_struct and instead adds
> an owner. This approach was suggested by Paul Menage. The advantage of
> this approach is that, once the mm->owner is known, using the subsystem
> id, the cgroup can be determined. It also allows several control groups
> that are virtually grouped by mm_struct, to exist independent of the memory
> controller i.e., without adding mem_cgroup's for each controller,
> to mm_struct.
> 
> The code initially assigns mm->owner to the task and then after the
> thread group leader is identified. The mm->owner is changed to the thread
> group leader of the task later at the end of copy_process.
> 
Hmm, I like this approach. 

-a bit off topic-
BTW, could you move mem_cgroup_from_task() to include/linux/memcontrol.h ?

Then, I'll add an interface like
mem_cgroup_charge_xxx(struct page *page, struct mem_cgroup *mem, gfp_mask mask)

This can be called in following way:
mem_cgroup_charge_xxx(page, mem_cgroup_from_task(current), GFP_XXX);
and I don't have to access mm_struct's member in this case.

Thanks,
-Kame

