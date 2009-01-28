Return-Path: <linux-kernel-owner+w=401wt.eu-S1752747AbZA1AKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbZA1AKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 19:10:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbZA1AKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 19:10:39 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33777 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbZA1AKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 19:10:38 -0500
Date: Wed, 28 Jan 2009 09:09:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "menage@google.com" <menage@google.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [FIX][PATCH 6/7] cgroup/memcg: fix frequent -EBUSY at rmdir
Message-Id: <20090128090924.23653c8c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090126165823.dcf9cf78.randy.dunlap@oracle.com>
References: <20090122183411.3cabdfd2.kamezawa.hiroyu@jp.fujitsu.com>
	<20090122184018.5cd3c3b9.kamezawa.hiroyu@jp.fujitsu.com>
	<20090126165823.dcf9cf78.randy.dunlap@oracle.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2009 16:58:23 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Thu, 22 Jan 2009 18:40:18 +0900 KAMEZAWA Hiroyuki wrote:
> 
> >  Documentation/cgroups/cgroups.txt |    6 +-
> >  include/linux/cgroup.h            |   16 +-----
> >  kernel/cgroup.c                   |   97 ++++++++++++++++++++++++++++++++------
> >  mm/memcontrol.c                   |    5 +
> >  4 files changed, 93 insertions(+), 31 deletions(-)
> > 
> > Index: mmotm-2.6.29-Jan16/Documentation/cgroups/cgroups.txt
> > ===================================================================
> > --- mmotm-2.6.29-Jan16.orig/Documentation/cgroups/cgroups.txt
> > +++ mmotm-2.6.29-Jan16/Documentation/cgroups/cgroups.txt
> > @@ -478,11 +478,13 @@ cgroup->parent is still valid. (Note - c
> >  newly-created cgroup if an error occurs after this subsystem's
> >  create() method has been called for the new cgroup).
> >  
> > -void pre_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp);
> > +int pre_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp);
> >  
> >  Called before checking the reference count on each subsystem. This may
> >  be useful for subsystems which have some extra references even if
> > -there are not tasks in the cgroup.
> > +there are not tasks in the cgroup. If pre_destroy() returns error code,
> > +rmdir() will fail with it. From this behavior, pre_destroy() can be
> > +called plural times against a cgroup.
> 
> s/plural/multiple/ please.
> 
ok, thank you for review.

-Kame

> >  
> >  int can_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
> >  	       struct task_struct *task)
> 
> 
> ---
> ~Randy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

