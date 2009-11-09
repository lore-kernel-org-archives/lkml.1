Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202AbZKIHHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbZKIHHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 02:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbZKIHHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 02:07:41 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:53233 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbZKIHHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 02:07:40 -0500
Date: Mon, 9 Nov 2009 12:37:37 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] memcg : rewrite percpu countings with new
 interfaces
Message-ID: <20091109070737.GE3042@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20091106175242.6e13ee29.kamezawa.hiroyu@jp.fujitsu.com>
 <20091106175545.b97ee867.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091106175545.b97ee867.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-11-06 17:55:45]:

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Now, alloc_percpu() alloc good dynamic allocations and
> Recent updates on percpu.h gives us following kind of ops 
>    - __this_cpu_add() etc...
> This is designed to be a help for reduce code size in hot-path
> and very useful to handle percpu area. Thanks for great works.
> 
> This patch rewrite memcg's (not-good) percpu status with new
> percpu support macros. This decreases code size and instruction
> size. By this, this area is now NUMA-aware and may have performance 
> benefit. 
> 
> I got good result in parallel pagefault test. (my host is 8cpu/2socket)
> 
> before==
>  Performance counter stats for './runpause.sh' (5 runs):
> 
>   474070.055912  task-clock-msecs         #      7.881 CPUs    ( +-   0.013% )
>        35829310  page-faults              #      0.076 M/sec   ( +-   0.217% )
>      3803016722  cache-references         #      8.022 M/sec   ( +-   0.215% )  (scaled from 100.00%)
>      1104083123  cache-misses             #      2.329 M/sec   ( +-   0.961% )  (scaled from 100.00%)
> 
>    60.154982314  seconds time elapsed   ( +-   0.018% )
> 
> after==
>  Performance counter stats for './runpause.sh' (5 runs):
> 
>   474919.429670  task-clock-msecs         #      7.896 CPUs    ( +-   0.013% )
>        36520440  page-faults              #      0.077 M/sec   ( +-   1.854% )
>      3109834751  cache-references         #      6.548 M/sec   ( +-   0.276% )
>      1053275160  cache-misses             #      2.218 M/sec   ( +-   0.036% )
> 
>    60.146585280  seconds time elapsed   ( +-   0.019% )
> 
> This test is affected by cpu-utilization but I think more improvements
> will be found in bigger system.
>

Hi, Kamezawa-San,

Could you please post the IPC results as well? 

-- 
	Balbir
