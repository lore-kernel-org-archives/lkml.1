Return-Path: <linux-kernel-owner+w=401wt.eu-S937537AbXHMAd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937537AbXHMAd7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 20:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933138AbXHMAdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 20:33:51 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:43755 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763636AbXHMAdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 20:33:50 -0400
To: balbir@linux.vnet.ibm.com
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, ebiederm@xmission.com, containers@lists.osdl.org,
       menage@google.com, xemul@openvz.org
Subject: Re: [-mm PATCH 8/9] Memory controller add switch to control what type
	of pages to limit (v4)
In-Reply-To: Your message of "Sat, 28 Jul 2007 01:41:03 +0530"
	<20070727201103.31565.3104.sendpatchset@balbir-laptop>
References: <20070727201103.31565.3104.sendpatchset@balbir-laptop>
X-Mailer: Cue version 0.8 (070404-1613/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20070813003348.91E3E1BF943@siro.lan>
Date: Mon, 13 Aug 2007 09:33:48 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Choose if we want cached pages to be accounted or not. By default both
> are accounted for. A new set of tunables are added.
> 
> echo -n 1 > mem_control_type
> 
> switches the accounting to account for only mapped pages
> 
> echo -n 2 > mem_control_type
> 
> switches the behaviour back

MEM_CONTAINER_TYPE_ALL is 3, not 2.

YAMAMOTO Takashi

> +enum {
> +	MEM_CONTAINER_TYPE_UNSPEC = 0,
> +	MEM_CONTAINER_TYPE_MAPPED,
> +	MEM_CONTAINER_TYPE_CACHED,
> +	MEM_CONTAINER_TYPE_ALL,
> +	MEM_CONTAINER_TYPE_MAX,
> +} mem_control_type;
> +
> +static struct mem_container init_mem_container;

> +	mem = rcu_dereference(mm->mem_container);
> +	if (mem->control_type == MEM_CONTAINER_TYPE_ALL)
> +		return mem_container_charge(page, mm);
> +	else
> +		return 0;
