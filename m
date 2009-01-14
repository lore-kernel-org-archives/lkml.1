Return-Path: <linux-kernel-owner+w=401wt.eu-S1758552AbZANHJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbZANHJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 02:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbZANHJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 02:09:09 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38787 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbZANHJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 02:09:08 -0500
Date: Wed, 14 Jan 2009 16:07:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Rakib Mullick <rakib.mullick@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] memcg: fix section mismatch
Message-Id: <20090114160758.159415f5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <496D8E80.8070401@cn.fujitsu.com>
References: <496D8E80.8070401@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 15:04:32 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> At system boot when creating the top cgroup, mem_cgroup_create() calls
> enable_swap_cgroup() which is marked as __init, so mark mem_cgroup_create()
> as __ref to avoid false section mismatch warning.
> 
> Reported-by: Rakib Mullick <rakib.mullick@gmail.com>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by; KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
> 
> use __ref instead of __init_refok
> 
change log ?

> ---
>  mm/memcontrol.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e2996b8..e57afca 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2181,7 +2181,7 @@ static void __init enable_swap_cgroup(void)
>  }
>  #endif
>  
> -static struct cgroup_subsys_state *
> +static struct cgroup_subsys_state * __ref
>  mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
>  {
>  	struct mem_cgroup *mem, *parent;
> -- 
> 1.5.4.rc3
> 

