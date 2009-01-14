Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbZANFB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbZANFB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 00:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbZANFBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 00:01:18 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33065 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbZANFBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 00:01:17 -0500
Date: Wed, 14 Jan 2009 14:00:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Rakib Mullick" <rakib.mullick@gmail.com>
Cc: "Li Zefan" <lizf@cn.fujitsu.com>,
       "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>,
       mingo@elte.hu, "Andrew Morton" <akpm@linux-foundation.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] mm: Fix section mismatch in memcontrol.c
Message-Id: <20090114140010.3649cd2e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <b9df5fa10901132043j5a577b2fxeaaa4cc1fdd551f2@mail.gmail.com>
References: <b9df5fa10901122139h4bfb727i64f864ec185c731d@mail.gmail.com>
	<496C2B4F.3090406@cn.fujitsu.com>
	<20090113151307.e9ddc085.kamezawa.hiroyu@jp.fujitsu.com>
	<b9df5fa10901132043j5a577b2fxeaaa4cc1fdd551f2@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 10:43:24 +0600
"Rakib Mullick" <rakib.mullick@gmail.com> wrote:

> Sure. You can carryout your other jobs. Here is the patch.
> Thanks for your help guys.
> 
Thank you. I confirmed this fixes mismatch.

Could you send this with your Signed-off-by, again ?

you got my Ack.
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>



> --- linux-2.6-orig/mm/memcontrol.c	2009-01-12 09:53:10.000000000 +0600
> +++ linux-2.6/mm/memcontrol.c	2009-01-13 19:55:02.846459224 +0600
> @@ -2170,13 +2170,13 @@ static void mem_cgroup_put(struct mem_cg
> 
> 
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
> -static void __init enable_swap_cgroup(void)
> +static void __init_refok enable_swap_cgroup(void)
>  {
>  	if (!mem_cgroup_disabled() && really_do_swap_account)
>  		do_swap_account = 1;
>  }
>  #else
> -static void __init enable_swap_cgroup(void)
> +static void __init_refok enable_swap_cgroup(void)
>  {
>  }
>  #endif
> 
> 
> On 1/13/09, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Tue, 13 Jan 2009 13:49:03 +0800
> > Li Zefan <lizf@cn.fujitsu.com> wrote:
> >
> >> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> >>
> >> Rakib Mullick wrote:
> >> > Impact: Fix section mismatch warning.
> >> >
> >> > The annotation for __init in enable_swap_cgroup() and __initdata for
> >> > really_do_swap_account produces the following warning. Which is not
> >> > right, since this function is called from non-init section. This patch
> >> > fixes it. If anything else please notice.
> >> >
> >>
> >> I saw this warning on IA64. But this fix is wrong IMO.
> >>
> >> enable_swap_cgroup() will be called at system boot only:
> >>
> >> start_kernel()
> >>   cgroup_init()
> >>     mem_cgroup_create()
> >>       enable_swap_cgroup()
> >>
> >> I think the proper fix is annotate mem_cgroup_create() with __init_refok.
> >>
> > I think Li Zefan's fix is correct.
> > Could you make a patch ? or I'll schedule this as my work.
> >
> > Thanks,
> > -Kame
> >
> >
> >
> 

