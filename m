Return-Path: <linux-kernel-owner+w=401wt.eu-S1758717AbYFDGon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717AbYFDGon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 02:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758355AbYFDGo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 02:44:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61436 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754103AbYFDGoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 02:44:25 -0400
Message-ID: <4846394D.9010805@cn.fujitsu.com>
Date: Wed, 04 Jun 2008 14:42:21 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "menage@google.com" <menage@google.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>
Subject: Re: [RFC][PATCH 2/2] memcg: hardwall hierarhcy for memcg
References: <20080604135815.498eaf82.kamezawa.hiroyu@jp.fujitsu.com> <20080604140329.8db1b67e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080604140329.8db1b67e.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> Hard-Wall hierarchy support for memcg.
>  - new member hierarchy_model is added to memcg.
> 
> Only root cgroup can modify this only when there is no children.
> 
> Adds following functions for supporting HARDWALL hierarchy.
>  - try to reclaim memory at the change of "limit".
>  - try to reclaim all memory at force_empty
>  - returns resources to the parent at destroy.
> 
> Changelog v2->v3
>  - added documentation.
>  - hierarhcy_model parameter is added.
> 
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> ---
>  Documentation/controllers/memory.txt |   27 +++++-
>  mm/memcontrol.c                      |  156 ++++++++++++++++++++++++++++++++++-
>  2 files changed, 178 insertions(+), 5 deletions(-)
> 
> Index: temp-2.6.26-rc2-mm1/mm/memcontrol.c
> ===================================================================
> --- temp-2.6.26-rc2-mm1.orig/mm/memcontrol.c
> +++ temp-2.6.26-rc2-mm1/mm/memcontrol.c
> @@ -137,6 +137,8 @@ struct mem_cgroup {
>  	struct mem_cgroup_lru_info info;
>  
>  	int	prev_priority;	/* for recording reclaim priority */
> +
> +	int	hierarchy_model; /* used hierarchical policy */

hierarchy_model can be a global value instead of per cgroup value.
