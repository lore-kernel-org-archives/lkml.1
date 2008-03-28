Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbYC1LL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbYC1LL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 07:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbYC1LLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 07:11:20 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41324 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbYC1LLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 07:11:20 -0400
Date: Fri, 28 Mar 2008 20:15:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Paul Menage <menage@google.com>, Pavel Emelianov <xemul@openvz.org>,
       Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [-mm] Add an owner to the mm_struct (v2)
Message-Id: <20080328201528.55b22fba.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47ECCE00.70803@linux.vnet.ibm.com>
References: <20080328082316.6961.29044.sendpatchset@localhost.localdomain>
	<20080328195516.494edde3.kamezawa.hiroyu@jp.fujitsu.com>
	<47ECCE00.70803@linux.vnet.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2008 16:22:48 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> > How about changing this css_get()/css_put() from accounting against mm_struct
> > to accouting against task_struct ?
> > It seems simpler way after this mm->owner change.
> 
> But the reason why we account the mem_cgroup is that we don't want the
> mem_cgroup to be deleted. I hope you meant mem_cgroup instead of mm_struct.
> 
Ah, my text was complicated.

Now,
- css_get(memcgrp) is called at mm_struct initialization.
- css_put(memcgrp) is called at mm_struct freeing.

How about
- css_get(memcgrp) is called at task_struct initialization.
- css_put(memcgrp) is called at task_struct freeing.

Because
1. we find mem_cgroup by mm->owner, after this.
2. generic group interface have exit() and clone() callback interface.

mem_cgroup will not be freed until rmdir(), anyway.

Thanks,
-Kame

