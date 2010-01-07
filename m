Return-Path: <linux-kernel-owner+w=401wt.eu-S1752715Ab0AGFLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab0AGFLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 00:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025Ab0AGFLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 00:11:13 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51247 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab0AGFLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 00:11:12 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 7 Jan 2010 14:07:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mmotm] build fix for
 memcg-move-charges-of-anonymous-swap.patch
Message-Id: <20100107140758.c2f14802.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100107133026.6350bd9d.kamezawa.hiroyu@jp.fujitsu.com>
References: <201001062259.o06MxQrp023236@imap1.linux-foundation.org>
	<20100106171058.f1d6f393.randy.dunlap@oracle.com>
	<20100107111319.7d95fe86.nishimura@mxp.nes.nec.co.jp>
	<20100107112150.2e585f1c.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107115901.594330d0.nishimura@mxp.nes.nec.co.jp>
	<20100107120233.f244d4b7.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107130609.31fe83dc.nishimura@mxp.nes.nec.co.jp>
	<20100107133026.6350bd9d.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010 13:30:26 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Thu, 7 Jan 2010 13:06:09 +0900
> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> 
> > build fix in !CONFIG_SWAP case.
> > 
> >   CC      mm/memcontrol.o
> > mm/memcontrol.c: In function 'is_target_pte_for_mc':
> > mm/memcontrol.c:3648: error: implicit declaration of function 'mem_cgroup_count_swap_user'
> > make[1]: *** [mm/memcontrol.o] Error 1
> > make: *** [mm] Error 2
> > 
> > Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 
> Hmm, this doesn't seem include fix for CONFIG_CGROUP_MEM_RES_CTLR_SWAP=n
> ==
> static int is_target_pte_for_mc(struct vm_area_struct *vma,
>                 unsigned long addr, pte_t ptent, union mc_target *target)
> {
> ....
>                 else if (is_swap_pte(ptent)) {
>                         ent = pte_to_swp_entry(ptent);
>                         if (!move_anon || non_swap_entry(ent))
>                                 return 0;
>                         usage_count = mem_cgroup_count_swap_user(ent, &page);
>                 }
> ==
> At least, !do_swap_account check is necessary, I think.
> I'm sorry if I miss something...
> 

Get follwoing after this patch with !CONFIG_SWAP case.
==
mm/built-in.o: In function `is_target_pte_for_mc':
/home/kamezawa/Kernel/ref-mmotm/mm/memcontrol.c:3985: undefined reference to `mem_cgroup_count_swap_user'


I think !do_swap_count check in is_target_pte_for_mc() should be added.

Thanks,
-Kame


