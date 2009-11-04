Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbZKDAFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbZKDAFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 19:05:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbZKDAFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 19:05:05 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59728 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbZKDAFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 19:05:04 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 4 Nov 2009 09:02:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, minchan.kim@gmail.com,
       vedran.furac@gmail.com, Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [RFC][-mm][PATCH 2/6] oom-killer: count swap usage per process.
Message-Id: <20091104090225.54a70927.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.0911031144390.11821@chino.kir.corp.google.com>
References: <20091102162244.9425e49b.kamezawa.hiroyu@jp.fujitsu.com>
	<20091102162526.c985c5a8.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0911031144390.11821@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Nov 2009 11:47:23 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Mon, 2 Nov 2009, KAMEZAWA Hiroyuki wrote:
> 
> > Now, anon_rss and file_rss is counted as RSS and exported via /proc.
> > RSS usage is important information but one more information which
> > is often asked by users is "usage of swap".(user support team said.)
> > 
> > This patch counts swap entry usage per process and show it via
> > /proc/<pid>/status. I think status file is robust against new entry.
> > Then, it is the first candidate..
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Acked-by; David Rientjes <rientjes@google.com>
> 
> Thanks!  I think this should be added to -mm now while the remainder of 
> your patchset is developed and reviewed, it's helpful as an independent 
> change.
> 
> > Index: mmotm-2.6.32-Nov2/fs/proc/task_mmu.c
> > ===================================================================
> > --- mmotm-2.6.32-Nov2.orig/fs/proc/task_mmu.c
> > +++ mmotm-2.6.32-Nov2/fs/proc/task_mmu.c
> > @@ -17,7 +17,7 @@
> >  void task_mem(struct seq_file *m, struct mm_struct *mm)
> >  {
> >  	unsigned long data, text, lib;
> > -	unsigned long hiwater_vm, total_vm, hiwater_rss, total_rss;
> > +	unsigned long hiwater_vm, total_vm, hiwater_rss, total_rss, swap;
> >  
> >  	/*
> >  	 * Note: to minimize their overhead, mm maintains hiwater_vm and
> > @@ -36,6 +36,8 @@ void task_mem(struct seq_file *m, struct
> >  	data = mm->total_vm - mm->shared_vm - mm->stack_vm;
> >  	text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK)) >> 10;
> >  	lib = (mm->exec_vm << (PAGE_SHIFT-10)) - text;
> > +
> > +	swap = get_mm_counter(mm, swap_usage);
> >  	seq_printf(m,
> >  		"VmPeak:\t%8lu kB\n"
> >  		"VmSize:\t%8lu kB\n"
> 
> Not sure about this newline though.

I'll clean up more. Thank you for pointing out.

Thanks,
-Kame

