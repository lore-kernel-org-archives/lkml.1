Return-Path: <linux-kernel-owner+w=401wt.eu-S1758022AbZDQATU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022AbZDQATU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755781AbZDQATL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:19:11 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54802 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594AbZDQATK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:19:10 -0400
Date: Fri, 17 Apr 2009 09:17:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add file based RSS accounting for memory resource
 controller (v2)
Message-Id: <20090417091737.27d71ab7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090417091459.dac2cc39.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090415120510.GX7082@balbir.in.ibm.com>
	<20090416095303.b4106e9f.kamezawa.hiroyu@jp.fujitsu.com>
	<20090416015955.GB7082@balbir.in.ibm.com>
	<20090416110246.c3fef293.kamezawa.hiroyu@jp.fujitsu.com>
	<20090416164036.03d7347a.kamezawa.hiroyu@jp.fujitsu.com>
	<20090416171535.cfc4ca84.kamezawa.hiroyu@jp.fujitsu.com>
	<20090416120316.GG7082@balbir.in.ibm.com>
	<20090417091459.dac2cc39.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Apr 2009 09:14:59 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> page_cgroup->mem_cgroup != try_get_mem_cgroup_from_mm(mm);  in many many cases.
> 
> For example, libc and /bin/*** is tend to be loaded into default cgroup at boot but
> used by many cgroups. But mapcount of page caches for /bin/*** is 0 if not running.
> 
> Then, File_Mapped can be greater than Cached easily if you use mm->owner.
> 
> I can't estimate RSS in *my* cgroup if File_Mapped includes pages which is under 
> other cgroups. It's meaningless.
> Especially, when Cached==0 but File_Mapped > 0, I think "oh, the kernel leaks somehing..hmm..."
> 
> By useing page_cgroup->mem_cgroup, we can avoid above mess.
> 
And, if pc->mem_cgroup is used, we can ignore "task move".

Thanks,
-Kame

