Return-Path: <linux-kernel-owner+w=401wt.eu-S1756069AbZC3Hxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbZC3Hxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 03:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbZC3HxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 03:53:17 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:49996 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbZC3HxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 03:53:16 -0400
Date: Mon, 30 Mar 2009 13:22:46 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH 7/8] memcg soft limit LRU reorder
Message-ID: <20090330075246.GA16497@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090327135933.789729cb.kamezawa.hiroyu@jp.fujitsu.com> <20090327141225.1e483acd.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090327141225.1e483acd.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-27 14:12:25]:

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> This patch adds a function to change the LRU order of pages in global LRU
> under control of memcg's victim of soft limit.
> 
> FILE and ANON victim is divided and LRU rotation will be done independently.
> (memcg which only includes FILE cache or ANON can exists.)
> 
> The routine finds specfied number of pages from memcg's LRU and
> move it to top of global LRU. They will be the first target of shrink_xxx_list.

This seems to be the core of the patch, but I don't like this very
much. Moving LRU pages of the mem cgroup seems very subtle, why can't
we directly use try_to_free_mem_cgroup_pages()?

-- 
	Balbir
