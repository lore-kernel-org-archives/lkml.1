Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbXK0CwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbXK0CwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 21:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbXK0CwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 21:52:07 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39558 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbXK0CwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 21:52:06 -0500
Date: Tue, 27 Nov 2007 11:55:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>,
       "kamezawa.hiroyu@jp.fujitsu.com" <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH][for -mm] per-zone and reclaim enhancements for memory
 controller take 3 [0/10] introduction
Message-Id: <20071127115525.e9779108.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, this is per-zone/reclaim support patch set for memory controller (cgroup).

Major changes from previous one is
 -- tested with 2.6.24-rc3-mm1 + ia64/NUMA
 -- applied comments.

I did small test on real NUMA machine.
My machine was ia64/8CPU/2Node NUMA. I tried to complile the kernel under 800M
bytes limit with 32 parallel make. (make -j 32)

 - 2.6.24-rc3-mm1 (+ scsi fix) .... shows soft lock-up.
   before soft lock-up, %sys was almost 100% in several times.

 - 2.6.24-rc3-mm1 (+ scsi fix) + this set .... completed succesfully
   It seems %iowait dominates the total performance.
   (current memory controller has no background reclaim)

Seems this set give us some progress.

(*) I'd like to merge YAMAMOTO-san's background page reclaim for memory
    controller before discussing about the number of performance.

Andrew, could you pick these up to -mm ?

Patch series brief description:

[1/10] ... add scan_global_lru() macro  (clean up)
[2/10] ... nid/zid helper function for cgroup
[3/10] ... introduce per-zone object for memory controller and add
           active/inactive counter.
[4/10] ... calculate mapper_ratio per cgroup (for memory reclaim)
[5/10] ... calculate active/inactive imbalance per cgroup (based on [3])
[6/10] ... remember reclaim priority in memory controller
[7/10] ... calculate the number of pages to be reclaimed per cgroup

[8/10] ... modifies vmscan.c to isolate global-lru-reclaim and
           memory-cgroup-reclaim in obvious manner.
           (this patch uses functions defined in [4 - 7])
[9/10] ... implement per-zone-lru for cgroup (based on [3])
[10/10] ... implement per-zone lru lock for cgroup (based on [3][9])

Any comments are welcome.

Thanks,
-Kame
 



