Return-Path: <linux-kernel-owner+w=401wt.eu-S1753183AbYCRKSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbYCRKSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 06:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbYCRKR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 06:17:57 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48466 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbYCRKR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 06:17:57 -0400
Date: Tue, 18 Mar 2008 19:22:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: Re: [PATCH 2/4] Block I/O tracking
Message-Id: <20080318192233.89c5cc3e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080318.182906.104806991.taka@valinux.co.jp>
References: <20080318.182251.93858044.taka@valinux.co.jp>
	<20080318.182906.104806991.taka@valinux.co.jp>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2008 18:29:06 +0900 (JST)
Hirokazu Takahashi <taka@valinux.co.jp> wrote:

> Hi,
> 
> This patch implements the bio cgroup on the memory cgroup.
> 
> Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
> 
> 
> --- linux-2.6.25-rc5.pagecgroup2/include/linux/memcontrol.h	2008-03-18 12:45:14.000000000 +0900
> +++ linux-2.6.25-rc5-mm1/include/linux/memcontrol.h	2008-03-18 12:55:59.000000000 +0900
> @@ -54,6 +54,10 @@ struct page_cgroup {
>  	struct list_head lru;		/* per cgroup LRU list */
>  	struct mem_cgroup *mem_cgroup;
>  #endif /* CONFIG_CGROUP_MEM_RES_CTLR */
> +#ifdef  CONFIG_CGROUP_BIO
> +	struct list_head blist;		/* for bio_cgroup page list */
> +	struct bio_cgroup *bio_cgroup;
> +#endif

Hmm, definition like this
==
enum {
#ifdef CONFIG_CGROUP_MEM_RES_CTLR
	MEM_RES_CTLR,
#endif
#ifdef CONFIG_CGROURP_BIO
	BIO_CTLR,
#endif
	NR_VM_CTRL,
};

	void	*cgroups[NR_VM_CGROUP];
==
Can save another #ifdefs ?

And, blist seems to be just used for force_empty.
Do you really need this ? no alternative ?


Thanks,
-Kame

