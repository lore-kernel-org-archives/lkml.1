Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759584Ab0COCOc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 22:14:32 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:37923 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759311Ab0COCO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 22:14:29 -0400
Date: Mon, 15 Mar 2010 07:44:14 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Sachin Sant <sachinp@in.ibm.com>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       nishimura@mxp.nes.nec.co.jp, lizf@cn.fujitsu.com,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] memcg: avoid use cmpxchg in swap cgroup
 maintainance (Was Re: 34-rc1-git3 build failure with
 CGROUP_MEM_RES_CTLR_SWAP=y
Message-ID: <20100315021414.GH17643@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <4B9CBEE6.1090509@in.ibm.com>
 <20100315100202.eb735f59.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100315100202.eb735f59.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-03-15 10:02:02]:

> On Sun, 14 Mar 2010 16:18:06 +0530
> Sachin Sant <sachinp@in.ibm.com> wrote:
> 
> > On a PowerPC box, latest 34-rc1 git(d89b218b8...) fails to build
> > with CGROUPS_MEM_RES_CTRL_SWAP=y. 
> > 
> > LD      init/built-in.o
> > LD      .tmp_vmlinux1
> > mm/built-in.o: In function __xchg:
> > arch/powerpc/include/asm/system.h:331: undefined reference to .__xchg_called_with_bad_pointer
> > mm/built-in.o: In function __cmpxchg:
> > arch/powerpc/include/asm/system.h:474: undefined reference to .__cmpxchg_called_with_bad_pointer
> > make: *** [.tmp_vmlinux1] Error 1
> > 
> > The code in question was added via commit 024914477e...
> > 
> > memcg: move charges of anonymous swap
> > 
> Oh..ok, powerpc (and other archs?) can't do 2byte cmpxchg and xchg.
> Then, we should use spinlock rather than that.
> 
> How about this ? Nishimura-san, could you consider something better ?
> We need a quick fix.
>

Looks good to me

 
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

-- 
	Three Cheers,
	Balbir
