Return-Path: <linux-kernel-owner+w=401wt.eu-S1760348AbZE1J1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760348AbZE1J1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 05:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755852AbZE1J1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 05:27:40 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:60894 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751227AbZE1J1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 05:27:39 -0400
Date: Thu, 28 May 2009 18:27:40 +0900 (JST)
Message-Id: <20090528.182740.193697101.ryov@valinux.co.jp>
To: vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Subject: Re: [PATCH 15/20] io-controller: map async requests to appropriate
 cgroup
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <1243377729-2176-16-git-send-email-vgoyal@redhat.com>
References: <1243377729-2176-1-git-send-email-vgoyal@redhat.com>
	<1243377729-2176-16-git-send-email-vgoyal@redhat.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

> +#ifdef CONFIG_TRACK_ASYNC_CONTEXT
> +	if (elv_bio_sync(bio)) {
> +		/* sync io. Determine cgroup from submitting task context. */
> +		cgroup = task_cgroup(current, io_subsys_id);
> +		return cgroup;
> +	}
> +
> +	/* Async io. Determine cgroup from with cgroup id stored in page */
> +	bio_cgroup_id = get_blkio_cgroup_id(bio);
> +
> +	if (!bio_cgroup_id)
> +		return NULL;
> +
> +	cgroup = blkio_cgroup_lookup(bio_cgroup_id);
> +#else
> +	cgroup = task_cgroup(current, io_subsys_id);
> +#endif
> +	return cgroup;
> +}

There is a case where a kernel thread (such as device-mapper drivers)
submits a sync IO instead of a task which originates the IO. I think
you should always use get_blkio_cgroup_id() to determine cgroup.

Thanks,
Ryo Tsuruta
