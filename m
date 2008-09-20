Return-Path: <linux-kernel-owner+w=401wt.eu-S1752660AbYITEU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbYITEU4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 00:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbYITEUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 00:20:48 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46378 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbYITEUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 00:20:47 -0400
Date: Sat, 20 Sep 2008 13:27:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: righi.andrea@gmail.com, dm-devel@redhat.com, xen-devel@lists.xensource.com,
       containers@lists.linux-foundation.org, agk@sourceware.org,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       jens.axboe@oracle.com, balbir@linux.vnet.ibm.com,
       fernando@oss.ntt.co.jp, xemul@openvz.org
Subject: Re: [dm-devel] Re: dm-ioband + bio-cgroup benchmarks
Message-Id: <20080920132703.e74c8f89.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080919.123405.91829935.taka@valinux.co.jp>
References: <48D267B5.20402@gmail.com>
	<20080918150634.GH20640@redhat.com>
	<48D2715A.6060002@gmail.com>
	<20080919.123405.91829935.taka@valinux.co.jp>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008 12:34:05 +0900 (JST)
Hirokazu Takahashi <taka@valinux.co.jp> wrote:

> I've decided to get Ryo to post the accurate dirty-page tracking patch
> for bio-cgroup, which isn't perfect yet though. The memory controller
> never wants to support this tracking because migrating a page between
> memory cgroups is really heavy.
> 
> I also thought enhancing the memory controller would be good enough,
> but a lot of people said they wanted to control memory resource and
> block I/O resource separately.
> So you can create several bio-cgroup in one memory-cgroup,
> or you can use bio-cgroup without memory-cgroup.
> 
> I also have a plan to implement more acurate tracking mechanism
> on bio-cgroup after the memory cgroup team re-implement the infrastructure,
> which won't be supported by memory-cgroup.
> When a process are moved into another memory cgroup,
> the pages belonging to the process don't move to the new cgroup
> because migrating pages is so heavy. It's hard to find the pages
> from the process and migrating pages may cause some memory pressure.
> I'll implement this feature only on bio-cgroup with minimum overhead
> 
I really would like to move page_cgroup to new cgroup when the process moves...
But it's just in my plan and I'm not sure I can do it or not.

Anyway what's next for me is
 1. fix current discussion to remove page->page_cgroup pointer.
 2. reduce locks.
 3. support swap and swap-cache.

I think algorithm for (1), (2) is now getting smart.

Thanks,
-Kame

