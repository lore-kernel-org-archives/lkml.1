Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890AbZA0A64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbZA0A64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 19:58:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZA0A6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 19:58:47 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:54768 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbZA0A6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 19:58:46 -0500
Date: Mon, 26 Jan 2009 16:58:23 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "menage@google.com" <menage@google.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [FIX][PATCH 6/7] cgroup/memcg: fix frequent -EBUSY at rmdir
Message-Id: <20090126165823.dcf9cf78.randy.dunlap@oracle.com>
In-Reply-To: <20090122184018.5cd3c3b9.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090122183411.3cabdfd2.kamezawa.hiroyu@jp.fujitsu.com>
	<20090122184018.5cd3c3b9.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.497E5C33.01B3:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2009 18:40:18 +0900 KAMEZAWA Hiroyuki wrote:

>  Documentation/cgroups/cgroups.txt |    6 +-
>  include/linux/cgroup.h            |   16 +-----
>  kernel/cgroup.c                   |   97 ++++++++++++++++++++++++++++++++------
>  mm/memcontrol.c                   |    5 +
>  4 files changed, 93 insertions(+), 31 deletions(-)
> 
> Index: mmotm-2.6.29-Jan16/Documentation/cgroups/cgroups.txt
> ===================================================================
> --- mmotm-2.6.29-Jan16.orig/Documentation/cgroups/cgroups.txt
> +++ mmotm-2.6.29-Jan16/Documentation/cgroups/cgroups.txt
> @@ -478,11 +478,13 @@ cgroup->parent is still valid. (Note - c
>  newly-created cgroup if an error occurs after this subsystem's
>  create() method has been called for the new cgroup).
>  
> -void pre_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp);
> +int pre_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp);
>  
>  Called before checking the reference count on each subsystem. This may
>  be useful for subsystems which have some extra references even if
> -there are not tasks in the cgroup.
> +there are not tasks in the cgroup. If pre_destroy() returns error code,
> +rmdir() will fail with it. From this behavior, pre_destroy() can be
> +called plural times against a cgroup.

s/plural/multiple/ please.

>  
>  int can_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
>  	       struct task_struct *task)


---
~Randy
