Return-Path: <linux-kernel-owner+w=401wt.eu-S1753638AbZGBB25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbZGBB25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 21:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbZGBB2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 21:28:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53163 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbZGBB2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 21:28:50 -0400
Message-ID: <4A4C0D8F.20005@cn.fujitsu.com>
Date: Thu, 02 Jul 2009 09:29:51 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: use hash table to simulate the sparse array
References: <4A3F2E38.7030604@cn.fujitsu.com> <4A49D12A.9040901@cn.fujitsu.com> <20090630115949.GB5249@nowhere> <4A4ACA67.8000002@cn.fujitsu.com> <20090701192514.GA5740@nowhere>
In-Reply-To: <20090701192514.GA5740@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> 
> Hmm, I'm confused.
> When you map a new pid, you do the following:
> 
> +static void do_map_cmdline_index(unsigned int idx, unsigned int pid)
> +{
> +	unsigned int hash = hash_32(pid, SAVED_CMDLINES_SHIFT);
> +
> +	if (map_cmdline_to_pid(idx) != NO_CMDLINE_MAP)
> +		hlist_del(&indexes[idx].node);
> +	indexes[idx].pid = pid;
> +	hlist_add_head(&indexes[idx].node, &map_head[hash]);
> +}
> 
> Then if there was a pid that had the same hash, it is deleted
> from the hashlist and the new one steal his place, which
> lead me to think you won't have more than one entry per hash.
> 
> 

indexes[idx] is deleted, not "indexes[hash]".
idx is chosen by the FIFO algorithm(which I did not change).
It is the earliest mapped item, its place is replaced by new item.

So map_head[hash] may have 2 or more entries(with different idx).

The whole patch do one thing only:
implement map_pid_to_cmdline(pid), and make it equals to
original map_pid_to_cmdline[pid] always.





