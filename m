Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbZGFOTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbZGFOTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 10:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbZGFOS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 10:18:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34717 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbZGFOS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 10:18:56 -0400
Date: Mon, 6 Jul 2009 10:16:50 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Subject: Re: [PATCH 09/25] io-controller: Common hierarchical fair queuing
	code in elevaotor layer
Message-ID: <20090706141650.GD8279@redhat.com>
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com> <1246564917-19603-10-git-send-email-vgoyal@redhat.com> <4A51657B.7000008@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A51657B.7000008@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06, 2009 at 10:46:19AM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> > +static struct io_group *
> > +io_group_chain_alloc(struct request_queue *q, void *key, struct cgroup *cgroup)
> > +{
> > +	struct io_cgroup *iocg;
> > +	struct io_group *iog, *leaf = NULL, *prev = NULL;
> > +	gfp_t flags = GFP_ATOMIC |  __GFP_ZERO;
> > +
> > +	for (; cgroup != NULL; cgroup = cgroup->parent) {
> > +		iocg = cgroup_to_io_cgroup(cgroup);
> > +
> > +		iog = io_cgroup_lookup_group(iocg, key);
> > +		if (iog != NULL) {
> > +			/*
> > +			 * All the cgroups in the path from there to the
> > +			 * root must have a io_group for efqd, so we don't
> > +			 * need any more allocations.
> > +			 */
> > +			break;
> > +		}
> > +
> > +		iog = kzalloc_node(sizeof(*iog), flags, q->node);
> > +		if (!iog)
> > +			goto cleanup;
> > +
> > +		iog->iocg_id = css_id(&iocg->css);
> 
>   Hi Vivek,
> 
>   IMHO, The io_cgroup id is nothing more than keeping track the corresponding iocg.
>   So why not just store iocg pointer in io_group and just get rid of this complexity.
>   I'd like to post a patch to do this change, what's your opinion?
> 

Hi Gui,

You can try that but I suspect that there not much to be gained in
terms of number of lines of code or code complexity. Do try it out though
and we can then have a look at the patch.

Thanks
Vivek
