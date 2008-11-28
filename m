Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbYK1JdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbYK1JdI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 04:33:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbYK1Jcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 04:32:55 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:52070 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbYK1Jcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 04:32:54 -0500
Date: Fri, 28 Nov 2008 18:02:52 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Pavel Emelyanov <xemul@openvz.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>
Subject: [RFC][PATCH -mmotm 0/2] misc patches for memory cgroup hierarchy
Message-Id: <20081128180252.b7a73c86.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I'm writing some patches for memory cgroup hierarchy.

I think KAMEZAWA-san's cgroup-id patches are the most important pathes now,
but I post these patches as RFC before going further.

Patch descriptions:
- [1/2] take account of memsw
    mem_cgroup_hierarchical_reclaim checks only mem->res now.
    It should also check mem->memsw when do_swap_account.
- [2/2] avoid oom
    In previous implementation, mem_cgroup_try_charge checked the return
    value of mem_cgroup_try_to_free_pages, and just retried if some pages
    had been reclaimed.
    But now, try_charge(and mem_cgroup_hierarchical_reclaim called from it)
    only checks whether the usage is less than the limit.
    I see oom easily in some tests which didn't cause oom before.

Both patches are for memory-cgroup-hierarchical-reclaim-v4 patch series.

My current plan for memory cgroup hierarchy:
- If hierarchy is enabled, limit of child should not exceed that of parent.
- Change other calls for mem_cgroup_try_to_free_page() to
  mem_cgroup_hierarchical_reclaim() if possible.


Thanks,
Daisuke Nishimura.
