Return-Path: <linux-kernel-owner+w=401wt.eu-S1752101AbZH1HUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbZH1HUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 03:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbZH1HUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 03:20:13 -0400
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:50993 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbZH1HUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 03:20:12 -0400
Date: Fri, 28 Aug 2009 12:50:08 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH 1/5] memcg: change for softlimit.
Message-ID: <20090828072007.GH4889@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090828132015.10a42e40.kamezawa.hiroyu@jp.fujitsu.com> <20090828132321.e4a497bb.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090828132321.e4a497bb.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-08-28 13:23:21]:

> This patch tries to modify softlimit handling in memcg/res_counter.
> There are 2 reasons in general.
> 
>  1. soft_limit can use only against sub-hierarchy root.
>     Because softlimit tree is sorted by usage, putting prural groups
>     under hierarchy (which shares usage) will just adds noise and unnecessary
>     mess. This patch limits softlimit feature only to hierarchy root.
>     This will make softlimit-tree maintainance better. 
> 
>  2. In these days, it's reported that res_counter can be bottleneck in
>     massively parallel enviroment. We need to reduce jobs under spinlock.
>     The reason we check softlimit at res_counter_charge() is that any member
>     in hierarchy can have softlimit.
>     But by chages in "1", only hierarchy root has soft_limit. We can omit
>     hierarchical check in res_counter.
> 
> After this patch, soft limit is avaliable only for root of sub-hierarchy.
> (Anyway, softlimit for hierarchy children just makes users confused, hard-to-use)
>


I need some time to digest this change, if the root is a hiearchy root
then only root can support soft limits? I think the change makes it
harder to use soft limits. Please help me understand better. 

-- 
	Balbir
