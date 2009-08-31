Return-Path: <linux-kernel-owner+w=401wt.eu-S1752423AbZHaMtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbZHaMtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 08:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbZHaMtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 08:49:25 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:41507 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbZHaMtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 08:49:24 -0400
Date: Mon, 31 Aug 2009 18:19:20 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp, menage@google.com,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH 0/4] memcg: add support for hwpoison testing
Message-ID: <20090831124920.GN4770@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090831102640.092092954@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090831102640.092092954@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Wu Fengguang <fengguang.wu@intel.com> [2009-08-31 18:26:40]:

> Hi all,
> 
> In hardware poison testing, we want to inject hwpoison errors to pages
> of a collection of selected tasks, so that random tasks (eg. init) won't
> be killed in stress tests and lead to test failure.
> 
> Memory cgroup provides an ideal tool for tracking and testing these target
> process pages. All we have to do is to
> - export the memory cgroup id via cgroupfs
> - export two functions/structs for hwpoison_inject.c
> 
> This might be an unexpected usage of memory cgroup. The last patch and this
> script demonstrates how the exported interfaces are to be used to limit the
> scope of hwpoison injection.
> 
> 	test -d /cgroup/hwpoison && rmdir /cgroup/hwpoison
> 	mkdir /cgroup/hwpoison
> 
> 	usemem -m 100 -s 100 &   # eat 100MB and sleep 100s
> 	echo `pidof usemem` > /cgroup/hwpoison/tasks
> 
> ==>     memcg_id=$(</cgroup/hwpoison/memory.id)
> ==>     echo $memcg_id > /debug/hwpoison/corrupt-filter-memcg
> 
> 	# hwpoison all pfn
> 	pfn=0
> 	while true
> 	do      
> 		let pfn=pfn+1
> 		echo $pfn > /debug/hwpoison/corrupt-pfn
> 		if [ $? -ne 0 ]; then
> 			break
> 		fi
> 	done
> 
> Comments are welcome, thanks!
>

I took a quick look and the patches seem OKAY to me, but I have
question, can't we do all of this from user space? The bits about
id export and import the ids look like they can be replaced by names
in user space.
 
> Cheers,
> Fengguang
> -- 
> 

-- 
	Balbir
