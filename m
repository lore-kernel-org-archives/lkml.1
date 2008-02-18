Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbYBRIQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbYBRIQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 03:16:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753623AbYBRIPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 03:15:55 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:45952 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753290AbYBRIPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 03:15:54 -0500
Message-ID: <47B93DD6.9030309@linux.vnet.ibm.com>
Date: Mon, 18 Feb 2008 13:42:06 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcgroup: remove a useless VM_BUG_ON()
References: <47B9223C.9020106@linux.vnet.ibm.com> <20080218062209.DA59B1E3C58@siro.lan> <47B923C8.3090904@linux.vnet.ibm.com> <47B929EE.7080202@cn.fujitsu.com> <47B92D47.2050008@linux.vnet.ibm.com> <47B93518.6@cn.fujitsu.com>
In-Reply-To: <47B93518.6@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
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

This seems much better

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
