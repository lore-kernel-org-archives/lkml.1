Return-Path: <linux-kernel-owner+w=401wt.eu-S1757193AbYDRDdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193AbYDRDdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 23:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbYDRDc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 23:32:58 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44448 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbYDRDc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 23:32:58 -0400
Date: Fri, 18 Apr 2008 12:36:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, shiwh@cn.fujitsu.com,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>
Subject: Re: [PATCH] fix page_reset_bad_cgroup
Message-Id: <20080418123653.0234dc98.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080417202221.063aa171.akpm@linux-foundation.org>
References: <20080418121046.892c44a5.kamezawa.hiroyu@jp.fujitsu.com>
	<20080417202221.063aa171.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008 20:22:21 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 18 Apr 2008 12:10:46 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > page->page_cgroup is unsigned long. Should be cleared by 0UL.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > 
> > Index: linux-2.6.25/include/linux/memcontrol.h
> > ===================================================================
> > --- linux-2.6.25.orig/include/linux/memcontrol.h
> > +++ linux-2.6.25/include/linux/memcontrol.h
> > @@ -30,7 +30,7 @@ struct mm_struct;
> >  extern void mm_init_cgroup(struct mm_struct *mm, struct task_struct *p);
> >  extern void mm_free_cgroup(struct mm_struct *mm);
> >  
> > -#define page_reset_bad_cgroup(page)	((page)->page_cgroup = 0)
> > +#define page_reset_bad_cgroup(page)	((page)->page_cgroup = 0UL)
> 
> That's pretty cosmetic.
> 
> In fact it could be argued that we shouldn't do this.  "0" is zero
> regardless of the type of the LHS.  So if we later change page_cgroup to
> u32 or u16 or `struct superblock *', the old page_reset_bad_cgroup() will
> happily continue to work.  There's no need to make this code aware of
> page_cgroup's type, to this extent?
>
Ah, sorry. I was confused...please ignore.
(I debugged an user program which clear a pointer with 0, yesterday..)

-Kame



