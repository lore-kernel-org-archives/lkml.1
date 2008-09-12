Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbYILJeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbYILJeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 05:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbYILJeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 05:34:10 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49417 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbYILJeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 05:34:08 -0400
Date: Fri, 12 Sep 2008 18:35:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, "xemul@openvz.org" <xemul@openvz.org>,
       "hugh@veritas.com" <hugh@veritas.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, menage@google.com
Subject: Re: [RFC] [PATCH 0/9]  remove page_cgroup pointer (with some
 enhancements)
Message-Id: <20080912183540.6e7d2468.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080911200855.94d33d3b.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080911200855.94d33d3b.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2008 20:08:55 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> Peformance comparison is below.
> ==
> rc5-mm1
> ==
> Execl Throughput                           3006.5 lps   (29.8 secs, 3 samples)
> C Compiler Throughput                      1006.7 lpm   (60.0 secs, 3 samples)
> Shell Scripts (1 concurrent)               4863.7 lpm   (60.0 secs, 3 samples)
> Shell Scripts (8 concurrent)                943.7 lpm   (60.0 secs, 3 samples)
> Shell Scripts (16 concurrent)               482.7 lpm   (60.0 secs, 3 samples)
> Dc: sqrt(2) to 99 decimal places         124804.9 lpm   (30.0 secs, 3 samples)
> 
> After this series
> ==
> Execl Throughput                           3003.3 lps   (29.8 secs, 3 samples)
> C Compiler Throughput                      1008.0 lpm   (60.0 secs, 3 samples)
> Shell Scripts (1 concurrent)               4580.6 lpm   (60.0 secs, 3 samples)
> Shell Scripts (8 concurrent)                913.3 lpm   (60.0 secs, 3 samples)
> Shell Scripts (16 concurrent)               569.0 lpm   (60.0 secs, 3 samples)
> Dc: sqrt(2) to 99 decimal places         124918.7 lpm   (30.0 secs, 3 samples)
> 
> Hmm..no loss ? But maybe I should find what I can do to improve this.
> 
This is the latest number.
 - added "Used" flag as Balbir's one.
 - rewrote and optimize uncharge() path.
 - move bit_spinlock() (lock_page_cgroup()) to header file as inilned function.

Execl Throughput                           3064.9 lps   (29.8 secs, 3 samples)
C Compiler Throughput                       998.0 lpm   (60.0 secs, 3 samples)
Shell Scripts (1 concurrent)               4717.0 lpm   (60.0 secs, 3 samples)
Shell Scripts (8 concurrent)                928.3 lpm   (60.0 secs, 3 samples)
Shell Scripts (16 concurrent)               474.3 lpm   (60.0 secs, 3 samples)
Dc: sqrt(2) to 99 decimal places         127184.0 lpm   (30.0 secs, 3 samples)

Hmm..it seems something bad? in concurrent shell test.
(But this -mm's shell test is not trustable. 15% slowdown from rc4's.)

I tries to avoid mz->lru_lock (it was in my set), also. But I find I can't.
I postpone that. (maybe remove mz->lru_lock and depends on zone->lock is choice.
This make memcg's lru to be synchronized with global lru.)

Unfortunately, I'll be offline for 2 or 3 days. I'm sorry if I can't make
quick response.

Thanks,
-Kame




