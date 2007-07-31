Return-Path: <linux-kernel-owner+w=401wt.eu-S1755581AbXGaKSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbXGaKSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 06:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758357AbXGaKQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 06:16:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49228 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758316AbXGaKQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 06:16:39 -0400
Date: Tue, 31 Jul 2007 19:17:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Zoltan Menyhart <Zoltan.Menyhart@bull.net>
Cc: David Mosberger-Tang <dmosberger@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "tony.luck@intel.com" <tony.luck@intel.com>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] flush icache before set_pte take6. [4/4] optimization
 for cpus other than montecito
Message-Id: <20070731191749.0709c56e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <46AEF518.4000002@bull.net>
References: <20070731113543.93ffd964.kamezawa.hiroyu@jp.fujitsu.com>
	<20070731114155.5785123c.kamezawa.hiroyu@jp.fujitsu.com>
	<ed5aea430707302115h484620f1le51fc054436b273a@mail.gmail.com>
	<46AEF518.4000002@bull.net>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 10:38:48 +0200
Zoltan Menyhart <Zoltan.Menyhart@bull.net> wrote:

> David Mosberger-Tang wrote:
> > This seems crazy to me.  Flushing should occur according to the
> > *architecture*, not model-by-model.  Even if we happen to get "lucky"
> > on pre-Montecito CPUs, that doesn't justify such ugly hacks.  Or you
> > really want to debug this *again* come next CPU?
> > 
> >   --david
> 
> O.K. let's say we flush by default: the global flag is set.
> 
> We can have a (short) list of the CPU models which do not require
> this flush.
> 
> If all of the CPUs are on the list then clear the global flag. And:
> 
> static inline void sync_icache_dcache(pte_t pte) {
>        if (pte_exec(pte) && global_flag)
>                __sync_icache_dcache(pte);
> }
> 

Could we discuss this in other thread as "optimization for some cpus" and
push bug-fix patches first ?

If take5 or part of take6(patch 1,2) are not acceptable, I'll continue this
work on -rc2.

Thanks,
-Kame

