Return-Path: <linux-kernel-owner+w=401wt.eu-S1752332Ab0ATJiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab0ATJiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 04:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187Ab0ATJh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 04:37:59 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:34891 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab0ATJh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 04:37:57 -0500
Message-ID: <4B56CEF0.2040406@linux.vnet.ibm.com>
Date: Wed, 20 Jan 2010 15:07:52 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0b1 Thunderbird/3.0
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       kirill@shutemov.name
Subject: Re: [PATCH mmotm] memcg use generic percpu allocator instead of private
 one
References: <20100120161825.15c372ac.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100120161825.15c372ac.kamezawa.hiroyu@jp.fujitsu.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 January 2010 12:48 PM, KAMEZAWA Hiroyuki wrote:
> This patch is onto mmotm Jan/15.
> =
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> When per-cpu counter for memcg was implemneted, dynamic percpu allocator
> was not very good. But now, we have good one and useful macros.
> This patch replaces memcg's private percpu counter implementation with
> generic dynamic percpu allocator and macros.
> 
> The benefits are
> 	- We can remove private implementation.
> 	- The counters will be NUMA-aware. (Current one is not...)
> 	- This patch reduces sizeof(struct mem_cgroup). Then,
> 	  struct mem_cgroup may be fit in page size on small config.
> 
> By this, size of text is reduced.
>  [Before]
>  [kamezawa@bluextal mmotm-2.6.33-Jan15]$ size mm/memcontrol.o
>    text    data     bss     dec     hex filename
>   24373    2528    4132   31033    7939 mm/memcontrol.o
>  [After]
>  [kamezawa@bluextal mmotm-2.6.33-Jan15]$ size mm/memcontrol.o
>    text    data     bss     dec     hex filename
>   23913    2528    4132   30573    776d mm/memcontrol.o
> 
> This includes no functional changes.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


Before review, could you please post parallel pagefault data on a large
system, since root now uses these per cpu counters and its overhead is
now dependent on these counters. Also the data read from root cgroup is
also dependent on these, could you make sure that is not broken.

Balbir
