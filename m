Return-Path: <linux-kernel-owner+w=401wt.eu-S1760257AbXK2DTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760257AbXK2DTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 22:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757160AbXK2DTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 22:19:38 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:58519 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755601AbXK2DTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 22:19:38 -0500
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       containers@lists.osdl.org, akpm@linux-foundation.org,
       balbir@linux.vnet.ibm.com
Subject: Re: [PATCH][for -mm] per-zone and reclaim enhancements for memory
 controller take 3 [3/10] per-zone active inactive counter
In-Reply-To: Your message of "Tue, 27 Nov 2007 12:00:48 +0900"
	<20071127120048.ef5f2005.kamezawa.hiroyu@jp.fujitsu.com>
References: <20071127120048.ef5f2005.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Cue version 0.8 (070404-1613/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20071129031937.3C86F1CFE80@siro.lan>
Date: Thu, 29 Nov 2007 12:19:37 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -651,10 +758,11 @@
>  		/* Avoid race with charge */
>  		atomic_set(&pc->ref_cnt, 0);
>  		if (clear_page_cgroup(page, pc) == pc) {
> +			int active;
>  			css_put(&mem->css);
> +			active = pc->flags & PAGE_CGROUP_FLAG_ACTIVE;
>  			res_counter_uncharge(&mem->res, PAGE_SIZE);
> -			list_del_init(&pc->lru);
> -			mem_cgroup_charge_statistics(mem, pc->flags, false);
> +			__mem_cgroup_remove_list(pc);
>  			kfree(pc);
>  		} else 	/* being uncharged ? ...do relax */
>  			break;

'active' seems unused.

YAMAMOTO Takashi
