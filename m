Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbZBZHlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbZBZHlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 02:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbZBZHlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 02:41:14 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47039 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbZBZHlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 02:41:14 -0500
Date: Thu, 26 Feb 2009 16:39:54 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] cpuset: cleanups and fixes
Message-Id: <20090226163954.db4af9fc.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <49A63E77.9060603@cn.fujitsu.com>
References: <49A63E77.9060603@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Feb 2009 15:02:15 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> This patchset mainly simplifies update_tasks_nodemask() and makes it
> return void (won't fail), thus fix a case that writing to cpuset.mems
> returns -ENOMEM but its mems_allowed has been changed.
> 
> [PATCH 1/4] cgroups: add 'data' field to struct cgroup_scanner
> [PATCH 2/4] cpuset: rewrite update_tasks_nodemask()
> [PATCH 3/4] cpuset: avoid changing cpuset's mems when errno returned
> [PATCH 4/4] cpuset: remove struct cpuset_hotplug_scanner
> 
Thank you. I think there is no problematic in your patch.

After reading your patch, I wonder we can improve this migration by
filter for cgroup_scan_tasks().

Assume a task with tons of threads in a cgroup and
  - change nodemask
  - migrate=1

Under current implemntation, cpuset_migrate_mm=>do_migrate_mm is called per
threads. This implies there will be big overhead, useless scanning of page
tables.

Can we add some checks as "Is this mm already migrated ?", anywhere ?
(we may need to add some another array, again...)

Thanks,
-Kame







> ---
>  include/linux/cgroup.h |    1
>  kernel/cpuset.c        |  151 +++++++++++++++++++------------------------------
>  2 files changed, 62 insertions(+), 90 deletions(-)
> ---
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

