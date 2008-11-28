Return-Path: <linux-kernel-owner+w=401wt.eu-S1753593AbYK1Kui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbYK1Kui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 05:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbYK1Ku3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 05:50:29 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50163 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbYK1Ku3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 05:50:29 -0500
Date: Fri, 28 Nov 2008 19:49:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>
Subject: Re: [RFC][PATCH -mmotm 0/2] misc patches for memory cgroup
 hierarchy
Message-Id: <20081128194938.508a3b22.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081128180252.b7a73c86.nishimura@mxp.nes.nec.co.jp>
References: <20081128180252.b7a73c86.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2008 18:02:52 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> Hi.
> 
> I'm writing some patches for memory cgroup hierarchy.
> 
> I think KAMEZAWA-san's cgroup-id patches are the most important pathes now,
> but I post these patches as RFC before going further.
> 
Don't wait me ;) I'll rebase mine.


> Patch descriptions:
> - [1/2] take account of memsw
>     mem_cgroup_hierarchical_reclaim checks only mem->res now.
>     It should also check mem->memsw when do_swap_account.
> - [2/2] avoid oom
>     In previous implementation, mem_cgroup_try_charge checked the return
>     value of mem_cgroup_try_to_free_pages, and just retried if some pages
>     had been reclaimed.
>     But now, try_charge(and mem_cgroup_hierarchical_reclaim called from it)
>     only checks whether the usage is less than the limit.
>     I see oom easily in some tests which didn't cause oom before.
> 
> Both patches are for memory-cgroup-hierarchical-reclaim-v4 patch series.
> 
> My current plan for memory cgroup hierarchy:
> - If hierarchy is enabled, limit of child should not exceed that of parent.
 limit of a child or
 limit of sum of children ?

> - Change other calls for mem_cgroup_try_to_free_page() to
>   mem_cgroup_hierarchical_reclaim() if possible.
> 
 maybe makes sense.

Thanks,
-Kame

