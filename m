Return-Path: <linux-kernel-owner+w=401wt.eu-S1756948AbZEHMsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948AbZEHMsg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 08:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757772AbZEHMsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 08:48:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43135 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759738AbZEHMsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 08:48:14 -0400
Date: Fri, 8 May 2009 08:45:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com,
       snitzer@redhat.com, m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
Subject: Re: [PATCH 05/18] io-controller: Common hierarchical fair queuing
	code in elevaotor layer
Message-ID: <20090508124542.GC7293@redhat.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <1241553525-28095-6-git-send-email-vgoyal@redhat.com> <4A0290ED.7080506@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0290ED.7080506@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 03:42:37PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> > This patch enables hierarchical fair queuing in common layer. It is
> > controlled by config option CONFIG_GROUP_IOSCHED.
> ...
> > +}
> > +
> > +void iocg_destroy(struct cgroup_subsys *subsys, struct cgroup *cgroup)
> > +{
> > +	struct io_cgroup *iocg = cgroup_to_io_cgroup(cgroup);
> > +	struct hlist_node *n, *tmp;
> > +	struct io_group *iog;
> > +
> > +	/*
> > +	 * Since we are destroying the cgroup, there are no more tasks
> > +	 * referencing it, and all the RCU grace periods that may have
> > +	 * referenced it are ended (as the destruction of the parent
> > +	 * cgroup is RCU-safe); bgrp->group_data will not be accessed by
> > +	 * anything else and we don't need any synchronization.
> > +	 */
> > +	hlist_for_each_entry_safe(iog, n, tmp, &iocg->group_data, group_node)
> > +		io_destroy_group(iocg, iog);
> > +
> > +	BUG_ON(!hlist_empty(&iocg->group_data));
> > +
> 
>     Hi Vivek,
> 
>     IMHO, free_css_id() needs to be called here.
> 

Thanks. Sure, will do in next version.

Thanks
Vivek
