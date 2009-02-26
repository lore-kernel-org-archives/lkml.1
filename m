Return-Path: <linux-kernel-owner+w=401wt.eu-S1754291AbZBZILQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbZBZILQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 03:11:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbZBZILA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 03:11:00 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41533 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbZBZILA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 03:11:00 -0500
Date: Thu, 26 Feb 2009 17:09:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] cpuset: cleanups and fixes
Message-Id: <20090226170938.3f5f32a4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <49A64BAA.7050401@cn.fujitsu.com>
References: <49A63E77.9060603@cn.fujitsu.com>
	<20090226163954.db4af9fc.kamezawa.hiroyu@jp.fujitsu.com>
	<49A64BAA.7050401@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Feb 2009 15:58:34 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > On Thu, 26 Feb 2009 15:02:15 +0800
> > Li Zefan <lizf@cn.fujitsu.com> wrote:
> > 
> >> This patchset mainly simplifies update_tasks_nodemask() and makes it
> >> return void (won't fail), thus fix a case that writing to cpuset.mems
> >> returns -ENOMEM but its mems_allowed has been changed.
> >>
> >> [PATCH 1/4] cgroups: add 'data' field to struct cgroup_scanner
> >> [PATCH 2/4] cpuset: rewrite update_tasks_nodemask()
> >> [PATCH 3/4] cpuset: avoid changing cpuset's mems when errno returned
> >> [PATCH 4/4] cpuset: remove struct cpuset_hotplug_scanner
> >>
> > Thank you. I think there is no problematic in your patch.
> > 
> > After reading your patch, I wonder we can improve this migration by
> > filter for cgroup_scan_tasks().
> > 
> > Assume a task with tons of threads in a cgroup and
> >   - change nodemask
> >   - migrate=1
> > 
> > Under current implemntation, cpuset_migrate_mm=>do_migrate_mm is called per
> > threads. This implies there will be big overhead, useless scanning of page
> > tables.
> > 
> > Can we add some checks as "Is this mm already migrated ?", anywhere ?
> > (we may need to add some another array, again...)
> > 
> 
> cpuset's memory_migrate flag is disabled by default, and I guess migrating mm
> in cpuset is not frequently used? I tend to not optimise it unless it becomes
> a problem in real-life. :)
> 

Ok, I will do by myself.
-Kame

