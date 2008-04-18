Return-Path: <linux-kernel-owner+w=401wt.eu-S1757278AbYDRD2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbYDRD2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 23:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754244AbYDRD2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 23:28:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754063AbYDRD2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 23:28:04 -0400
Date: Thu, 17 Apr 2008 20:22:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, shiwh@cn.fujitsu.com,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>
Subject: Re: [PATCH] fix page_reset_bad_cgroup
Message-Id: <20080417202221.063aa171.akpm@linux-foundation.org>
In-Reply-To: <20080418121046.892c44a5.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080418121046.892c44a5.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 12:10:46 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> page->page_cgroup is unsigned long. Should be cleared by 0UL.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> 
> Index: linux-2.6.25/include/linux/memcontrol.h
> ===================================================================
> --- linux-2.6.25.orig/include/linux/memcontrol.h
> +++ linux-2.6.25/include/linux/memcontrol.h
> @@ -30,7 +30,7 @@ struct mm_struct;
>  extern void mm_init_cgroup(struct mm_struct *mm, struct task_struct *p);
>  extern void mm_free_cgroup(struct mm_struct *mm);
>  
> -#define page_reset_bad_cgroup(page)	((page)->page_cgroup = 0)
> +#define page_reset_bad_cgroup(page)	((page)->page_cgroup = 0UL)

That's pretty cosmetic.

In fact it could be argued that we shouldn't do this.  "0" is zero
regardless of the type of the LHS.  So if we later change page_cgroup to
u32 or u16 or `struct superblock *', the old page_reset_bad_cgroup() will
happily continue to work.  There's no need to make this code aware of
page_cgroup's type, to this extent?


