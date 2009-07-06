Return-Path: <linux-kernel-owner+w=401wt.eu-S1756678AbZGFCrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbZGFCrF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 22:47:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbZGFCqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 22:46:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57787 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753829AbZGFCqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 22:46:53 -0400
Message-ID: <4A51657B.7000008@cn.fujitsu.com>
Date: Mon, 06 Jul 2009 10:46:19 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
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
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com> <1246564917-19603-10-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1246564917-19603-10-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
...
> +static struct io_group *
> +io_group_chain_alloc(struct request_queue *q, void *key, struct cgroup *cgroup)
> +{
> +	struct io_cgroup *iocg;
> +	struct io_group *iog, *leaf = NULL, *prev = NULL;
> +	gfp_t flags = GFP_ATOMIC |  __GFP_ZERO;
> +
> +	for (; cgroup != NULL; cgroup = cgroup->parent) {
> +		iocg = cgroup_to_io_cgroup(cgroup);
> +
> +		iog = io_cgroup_lookup_group(iocg, key);
> +		if (iog != NULL) {
> +			/*
> +			 * All the cgroups in the path from there to the
> +			 * root must have a io_group for efqd, so we don't
> +			 * need any more allocations.
> +			 */
> +			break;
> +		}
> +
> +		iog = kzalloc_node(sizeof(*iog), flags, q->node);
> +		if (!iog)
> +			goto cleanup;
> +
> +		iog->iocg_id = css_id(&iocg->css);

  Hi Vivek,

  IMHO, The io_cgroup id is nothing more than keeping track the corresponding iocg.
  So why not just store iocg pointer in io_group and just get rid of this complexity.
  I'd like to post a patch to do this change, what's your opinion?

-- 
Regards
Gui Jianfeng

