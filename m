Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774AbYK1SSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbYK1SSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 13:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbYK1SSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 13:18:44 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:56845 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbYK1SSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 13:18:43 -0500
Date: Fri, 28 Nov 2008 23:48:35 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Pavel Emelyanov <xemul@openvz.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>
Subject: Re: [RFC][PATCH -mmotm 0/2] misc patches for memory cgroup
	hierarchy
Message-ID: <20081128181835.GA12948@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
	LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Pavel Emelyanov <xemul@openvz.org>, Li Zefan <lizf@cn.fujitsu.com>,
	Paul Menage <menage@google.com>
References: <20081128180252.b7a73c86.nishimura@mxp.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081128180252.b7a73c86.nishimura@mxp.nes.nec.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> [2008-11-28 18:02:52]:

> Hi.
> 
> I'm writing some patches for memory cgroup hierarchy.
> 
> I think KAMEZAWA-san's cgroup-id patches are the most important pathes now,
> but I post these patches as RFC before going further.
> 
> Patch descriptions:
> - [1/2] take account of memsw
>     mem_cgroup_hierarchical_reclaim checks only mem->res now.
>     It should also check mem->memsw when do_swap_account.
> - [2/2] avoid oom
>     In previous implementation, mem_cgroup_try_charge checked the return
>     value of mem_cgroup_try_to_free_pages, and just retried if some pages
>     had been reclaimed.
>     But now, try_charge(and mem_cgroup_hierarchical_reclaim called from it)
>     only checks whether the usage is less than the limit.
>     I see oom easily in some tests which didn't cause oom before.
> 
> Both patches are for memory-cgroup-hierarchical-reclaim-v4 patch series.
> 
> My current plan for memory cgroup hierarchy:
> - If hierarchy is enabled, limit of child should not exceed that of parent.
> - Change other calls for mem_cgroup_try_to_free_page() to
>   mem_cgroup_hierarchical_reclaim() if possible.
>

Thanks, Daisuke,

I am in a conference and taken a quick look. The patches seem sane,
but I've not reviewed them carefully. I'll revert back next week
 

-- 
	Balbir
