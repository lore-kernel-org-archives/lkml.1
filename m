Return-Path: <linux-kernel-owner+w=401wt.eu-S1760845AbYDBSyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760845AbYDBSyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:54:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758667AbYDBSxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:53:51 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:43372 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757023AbYDBSxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:53:50 -0400
Message-ID: <47F3D62E.4070808@linux.vnet.ibm.com>
Date: Thu, 03 Apr 2008 00:23:34 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>, Pavel Emelianov <xemul@openvz.org>
CC: Hugh Dickins <hugh@veritas.com>, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][-mm] Add an owner to the mm_struct (v4)
References: <20080401124312.23664.64616.sendpatchset@localhost.localdomain>
In-Reply-To: <20080401124312.23664.64616.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> Changelog v3
> ------------
> 
> 1. Add mm->owner change callbacks using cgroups
> 
> This patch removes the mem_cgroup member from mm_struct and instead adds
> an owner. This approach was suggested by Paul Menage. The advantage of
> this approach is that, once the mm->owner is known, using the subsystem
> id, the cgroup can be determined. It also allows several control groups
> that are virtually grouped by mm_struct, to exist independent of the memory
> controller i.e., without adding mem_cgroup's for each controller,
> to mm_struct.
> 
> A new config option CONFIG_MM_OWNER is added and the memory resource
> controller selects this config option.
> 
> NOTE: This patch was developed on top of 2.6.25-rc5-mm1 and is applied on top
> of the memory-controller-move-to-own-slab patch (which is already present
> in the Andrew's patchset).
> 
> This patch also adds cgroup callbacks to notify subsystems when mm->owner
> changes. The mm_cgroup_changed callback is called with the task_lock()
> of the new task held and is called just prior to changing the mm->owner.
> 
> I am indebted to Paul Menage for the several reviews of this patchset
> and helping me make it lighter and simpler.
> 
> This patch was tested on a powerpc box.
> 
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Hi,

So far I've heard no objections or seen any review suggestions. Paul if you are
OK with this patch, I'll ask Andrew to include it in -mm.

People waiting on this patch

1. Pekka Enberg for revoke* syscalls
2. Serge Hallyn for swap namespaces
3. Myself to implement the rlimit controller for cgroups

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
