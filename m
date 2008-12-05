Return-Path: <linux-kernel-owner+w=401wt.eu-S1757332AbYLENW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbYLENW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 08:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbYLENWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 08:22:49 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37892 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbYLENWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 08:22:49 -0500
Message-ID: <56250.10.75.179.61.1228483365.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20081205212304.f7018ea1.nishimura@mxp.nes.nec.co.jp>
References: <20081205212208.31d904e0.nishimura@mxp.nes.nec.co.jp>
    <20081205212304.f7018ea1.nishimura@mxp.nes.nec.co.jp>
Date: Fri, 5 Dec 2008 22:22:45 +0900 (JST)
Subject: Re: [RFC][PATCH -mmotm 1/4] memcg: don't trigger oom at page 
     migration
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Daisuke Nishimura" <nishimura@mxp.nes.nec.co.jp>
Cc: "LKML" <linux-kernel@vger.kernel.org>, "linux-mm" <linux-mm@kvack.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Pavel Emelyanov" <xemul@openvz.org>, "Li Zefan" <lizf@cn.fujitsu.com>,
       "Paul Menage" <menage@google.com>, nishimura@mxp.nes.nec.co.jp
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain;charset=us-ascii
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daisuke Nishimura said:
> I think triggering OOM at mem_cgroup_prepare_migration would be just a bit
> overkill.
> Returning -ENOMEM would be enough for mem_cgroup_prepare_migration.
> The caller would handle the case anyway.
>
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


> ---
>  mm/memcontrol.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 4dbce1d..50ee1be 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1330,7 +1330,7 @@ int mem_cgroup_prepare_migration(struct page *page,
> struct mem_cgroup **ptr)
>  	unlock_page_cgroup(pc);
>
>  	if (mem) {
> -		ret = mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem);
> +		ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem, false);
>  		css_put(&mem->css);
>  	}
>  	*ptr = mem;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


