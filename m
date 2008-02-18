Return-Path: <linux-kernel-owner+w=401wt.eu-S1754950AbYBRGkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbYBRGkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 01:40:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbYBRGkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 01:40:00 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:52978 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752205AbYBRGj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 01:39:59 -0500
To: lizf@cn.fujitsu.com
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com
Subject: Re: [PATCH 2/3] memcgroup: fix typo in VM_BUG_ON()
In-Reply-To: Your message of "Mon, 18 Feb 2008 13:59:30 +0800"
	<47B91EC2.3020805@cn.fujitsu.com>
References: <47B91EC2.3020805@cn.fujitsu.com>
X-Mailer: Cue version 0.8 (070404-1613/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20080218063958.EE5881E3C11@siro.lan>
Date: Mon, 18 Feb 2008 15:39:58 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No need for VM_BUG_ON(pc), since 'pc' is the list entry. This should
> be VM_BUG_ON(page).
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/memcontrol.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6bded84..c2959ee 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -534,7 +534,7 @@ unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
>  		if (scan >= nr_to_scan)
>  			break;
>  		page = pc->page;
> -		VM_BUG_ON(!pc);
> +		VM_BUG_ON(!page);

can't page be NULL here if mem_cgroup_uncharge clears pc->page behind us?
ie. bug.

YAMAMOTO Takashi
