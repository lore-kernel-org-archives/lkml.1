Return-Path: <linux-kernel-owner+w=401wt.eu-S1753662Ab0A1Ke0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab0A1Ke0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 05:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755Ab0A1KeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 05:34:25 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33343 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab0A1KeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 05:34:24 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 28 Jan 2010 19:30:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, minchan.kim@gmail.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 1/2] sysctl clean up vm related variable declarations
Message-Id: <20100128193057.41523885.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1001280048110.15953@chino.kir.corp.google.com>
References: <20100121145905.84a362bb.kamezawa.hiroyu@jp.fujitsu.com>
	<20100122152332.750f50d9.kamezawa.hiroyu@jp.fujitsu.com>
	<20100125151503.49060e74.kamezawa.hiroyu@jp.fujitsu.com>
	<20100126151202.75bd9347.akpm@linux-foundation.org>
	<20100127085355.f5306e78.kamezawa.hiroyu@jp.fujitsu.com>
	<20100126161952.ee267d1c.akpm@linux-foundation.org>
	<20100127095812.d7493a8f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100127153053.b8a8a1a1.kamezawa.hiroyu@jp.fujitsu.com>
	<20100127153232.f8efc531.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1001280048110.15953@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jan 2010 00:54:49 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> > ---
> >  include/linux/mm.h     |    5 +++++
> >  include/linux/mmzone.h |    1 +
> >  include/linux/oom.h    |    5 +++++
> >  kernel/sysctl.c        |   16 ++--------------
> >  mm/mmap.c              |    5 +++++
> >  5 files changed, 18 insertions(+), 14 deletions(-)
> > 
> > Index: mmotm-2.6.33-Jan15-2/include/linux/mm.h
> > ===================================================================
> > --- mmotm-2.6.33-Jan15-2.orig/include/linux/mm.h
> > +++ mmotm-2.6.33-Jan15-2/include/linux/mm.h
> > @@ -1432,6 +1432,7 @@ int in_gate_area_no_task(unsigned long a
> >  #define in_gate_area(task, addr) ({(void)task; in_gate_area_no_task(addr);})
> >  #endif	/* __HAVE_ARCH_GATE_AREA */
> >  
> > +extern int sysctl_drop_caches;
> >  int drop_caches_sysctl_handler(struct ctl_table *, int,
> >  					void __user *, size_t *, loff_t *);
> >  unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
> > @@ -1476,5 +1477,9 @@ extern int soft_offline_page(struct page
> >  
> >  extern void dump_page(struct page *page);
> >  
> > +#ifndef CONFIG_NOMMU
> > +extern int sysctl_nr_trim_pages;
> 
> This should be #ifndef CONFIG_MMU.
> 
yes...thank you for review.

Thanks,
-Kame

