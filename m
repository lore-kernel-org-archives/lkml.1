Return-Path: <linux-kernel-owner+w=401wt.eu-S1751258AbZL1Cam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258AbZL1Cam (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 21:30:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbZL1Cal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 21:30:41 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57729 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbZL1Cak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 21:30:40 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 28 Dec 2009 11:27:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: containers@lists.linux-foundation.org, linux-mm@kvack.org,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Alexander Shishkin <virtuoso@slind.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/4] cgroup notifications API and memory thresholds
Message-Id: <20091228112720.2087ae73.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <cover.1261858972.git.kirill@shutemov.name>
References: <cover.1261858972.git.kirill@shutemov.name>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Dec 2009 04:08:58 +0200
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> This patchset introduces eventfd-based API for notifications in cgroups and
> implements memory notifications on top of it.
> 
> It uses statistics in memory controler to track memory usage.
> 
> Output of time(1) on building kernel on tmpfs:
> 
> Root cgroup before changes:
> 	make -j2  506.37 user 60.93s system 193% cpu 4:52.77 total
> Non-root cgroup before changes:
> 	make -j2  507.14 user 62.66s system 193% cpu 4:54.74 total
> Root cgroup after changes (0 thresholds):
> 	make -j2  507.13 user 62.20s system 193% cpu 4:53.55 total
> Non-root cgroup after changes (0 thresholds):
> 	make -j2  507.70 user 64.20s system 193% cpu 4:55.70 total
> Root cgroup after changes (1 thresholds, never crossed):
> 	make -j2  506.97 user 62.20s system 193% cpu 4:53.90 total
> Non-root cgroup after changes (1 thresholds, never crossed):
> 	make -j2  507.55 user 64.08s system 193% cpu 4:55.63 total
> 
> Any comments?
> 
Hmm, 2 secs of overhead is added by this.
(larger than expected.)

But optimization/claun up after merging is okay to me because the function
itself is attractive.

Thanks,
-Kame



> v3 -> v4:
>  - documentation.
> 
> v2 -> v3:
>  - remove [RFC];
>  - rebased to 2.6.33-rc2;
>  - fixes based on comments;
>  - fixed potential race on event removing;
>  - use RCU-protected arrays to track trasholds.
> 
> v1 -> v2:
>  - use statistics instead of res_counter to track resource usage;
>  - fix bugs with locking.
> 
> v0 -> v1:
>  - memsw support implemented.
> 
> Kirill A. Shutemov (4):
>   cgroup: implement eventfd-based generic API for notifications
>   memcg: extract mem_group_usage() from mem_cgroup_read()
>   memcg: rework usage of stats by soft limit
>   memcg: implement memory thresholds
> 
>  Documentation/cgroups/cgroups.txt |   20 ++
>  Documentation/cgroups/memory.txt  |   19 ++-
>  include/linux/cgroup.h            |   24 +++
>  kernel/cgroup.c                   |  208 ++++++++++++++++++++++-
>  mm/memcontrol.c                   |  348 ++++++++++++++++++++++++++++++++++---
>  5 files changed, 590 insertions(+), 29 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

