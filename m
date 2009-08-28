Return-Path: <linux-kernel-owner+w=401wt.eu-S1752146AbZH1PKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbZH1PKP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 11:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbZH1PKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 11:10:14 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:43260 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbZH1PKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 11:10:13 -0400
Date: Fri, 28 Aug 2009 20:40:11 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH 2/5] memcg: uncharge in batched manner
Message-ID: <20090828151011.GS4889@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090828132015.10a42e40.kamezawa.hiroyu@jp.fujitsu.com> <20090828132438.b33828bc.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090828132438.b33828bc.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-08-28 13:24:38]:

> 
> In massive parallel enviroment, res_counter can be a performance bottleneck.
> This patch is a trial for reducing lock contention.
> One strong techinque to reduce lock contention is reducing calls by
> batching some amount of calls int one.
> 
> Considering charge/uncharge chatacteristic,
> 	- charge is done one by one via demand-paging.
> 	- uncharge is done by
> 		- in chunk at munmap, truncate, exit, execve...
> 		- one by one via vmscan/paging.
> 
> It seems we hace a chance to batched-uncharge.
> This patch is a base patch for batched uncharge. For avoiding
> scattering memcg's structure, this patch adds memcg batch uncharge
> information to the task. please see start/end usage in next patch.
>

Overall it is a very good idea, can't we do the uncharge at the poin
tof unmap_vmas, exit_mmap, etc so that we don't have to keep
additional data structures around. 

-- 
	Balbir
