Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbYBRIqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbYBRIqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 03:46:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbYBRIqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 03:46:00 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33891 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbYBRIp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 03:45:59 -0500
Date: Mon, 18 Feb 2008 17:48:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcgroup: remove a useless VM_BUG_ON()
Message-Id: <20080218174855.de9182c3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47B93518.6@cn.fujitsu.com>
References: <47B9223C.9020106@linux.vnet.ibm.com>
	<20080218062209.DA59B1E3C58@siro.lan>
	<47B923C8.3090904@linux.vnet.ibm.com>
	<47B929EE.7080202@cn.fujitsu.com>
	<47B92D47.2050008@linux.vnet.ibm.com>
	<47B93518.6@cn.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2008 15:34:48 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> Remove this VM_BUG_ON(), as Balbir stated:
> 
> We used to have a for loop with !list_empty() as a termination condition
> and VM_BUG_ON(!pc) is a spill over. With the new loop, VM_BUG_ON(!pc) does not
> make sense.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  mm/memcontrol.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 718acf8..631002d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -534,7 +534,6 @@ unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
>  		if (scan >= nr_to_scan)
>  			break;
>  		page = pc->page;
> -		VM_BUG_ON(!pc);
>  
>  		if (unlikely(!PageLRU(page)))
>  			continue;
> -- 
> 1.5.4.rc3
> 
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thanks,
-Kame

