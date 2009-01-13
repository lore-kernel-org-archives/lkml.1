Return-Path: <linux-kernel-owner+w=401wt.eu-S1760619AbZAMGRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760619AbZAMGRB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 01:17:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758767AbZAMGOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 01:14:17 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33357 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760044AbZAMGOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 01:14:14 -0500
Date: Tue, 13 Jan 2009 15:13:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Rakib Mullick <rakib.mullick@gmail.com>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] mm: Fix section mismatch in memcontrol.c
Message-Id: <20090113151307.e9ddc085.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <496C2B4F.3090406@cn.fujitsu.com>
References: <b9df5fa10901122139h4bfb727i64f864ec185c731d@mail.gmail.com>
	<496C2B4F.3090406@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2009 13:49:03 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> Rakib Mullick wrote:
> > Impact: Fix section mismatch warning.
> > 
> > The annotation for __init in enable_swap_cgroup() and __initdata for
> > really_do_swap_account produces the following warning. Which is not
> > right, since this function is called from non-init section. This patch
> > fixes it. If anything else please notice.
> > 
> 
> I saw this warning on IA64. But this fix is wrong IMO.
> 
> enable_swap_cgroup() will be called at system boot only:
> 
> start_kernel()
>   cgroup_init()
>     mem_cgroup_create()
>       enable_swap_cgroup()
> 
> I think the proper fix is annotate mem_cgroup_create() with __init_refok.
> 
I think Li Zefan's fix is correct. 
Could you make a patch ? or I'll schedule this as my work.

Thanks,
-Kame


