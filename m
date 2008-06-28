Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbYF1ERT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbYF1ERT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 00:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbYF1ERM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 00:17:12 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58670 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbYF1ERL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 00:17:11 -0400
Date: Sat, 28 Jun 2008 13:22:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [RFC 5/5] Memory controller soft limit reclaim on contention
Message-Id: <20080628132247.01e1ed30.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080627151906.31664.7247.sendpatchset@balbir-laptop>
References: <20080627151808.31664.36047.sendpatchset@balbir-laptop>
	<20080627151906.31664.7247.sendpatchset@balbir-laptop>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008 20:49:06 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> +
> +		while (count-- &&
> +			((mem = heap_delete_max(&mem_cgroup_heap)) != NULL)) {
> +			BUG_ON(!mem->on_heap);
> +			spin_unlock_irqrestore(&mem_cgroup_heap_lock, flags);
> +			nr_reclaimed += try_to_free_mem_cgroup_pages(mem,
> +								gfp_mask);
> +			cond_resched();
> +			spin_lock_irqsave(&mem_cgroup_heap_lock, flags);
> +			mem->on_heap = 0;
It seems "mem* is not on heap after heap_delete_max(), right ?
If so, I think this on_heap should be cleared right after heap_delete_max().


> +			/*
> +			 * What should be the basis of breaking out?
> +			 */
> +			if (nr_reclaimed)
> +				goto done;

why stops here ?

Thanks,
-Kame

