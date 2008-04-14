Return-Path: <linux-kernel-owner+w=401wt.eu-S1760267AbYDNHxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760267AbYDNHxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 03:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756565AbYDNHwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 03:52:55 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56137 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763AbYDNHwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 03:52:54 -0400
Date: Mon, 14 Apr 2008 16:46:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: kernel warning: tried to kill an mm-less task!
Message-Id: <20080414164647.1d4a0428.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4803030D.3070906@cn.fujitsu.com>
References: <4803030D.3070906@cn.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 15:09:01 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> When I ran the same test program I described in a previous patch,
> I got the following warning:
> 
> WARNING: at mm/oom_kill.c:320 __oom_kill_task+0x6d/0x101()
> Modules linked in: 
> 
> Pid: 3856, comm: a.out Not tainted 2.6.25-rc8-mm2 #37
>  [<ffffffff80243941>] warn_on_slowpath+0x64/0xa2
>  [<ffffffff80244e16>] printk+0x5e/0x7b
>  [<ffffffff8022b096>] page_count+0x25/0x49
>  [<ffffffff8022b2cd>] show_mem+0x125/0x15a
>  [<ffffffff8028f00f>] __oom_kill_task+0x6d/0x101
>  [<ffffffff8028f319>] oom_kill_process+0x16c/0x22e
>  [<ffffffff8028f72c>] select_bad_process+0xb0/0x122
>  [<ffffffff8028f8d3>] mem_cgroup_out_of_memory+0x65/0x8a
>  [<ffffffff802bee84>] mem_cgroup_charge_common+0xf8/0x215
>  [<ffffffff802a14ac>] handle_mm_fault+0x216/0x6c8
>  [<ffffffff8029ebca>] follow_page+0x191/0x27d
>  [<ffffffff80234155>] need_resched+0x31/0x4f
>  [<ffffffff802a1c53>] get_user_pages+0x2f5/0x3eb
>  [<ffffffff802a1f64>] make_pages_present+0x9e/0xca
>  [<ffffffff802a51fc>] mmap_region+0x38c/0x452
>  [<ffffffff802119c4>] arch_get_unmapped_area_topdown+0x1bf/0x2a7
>  [<ffffffff802a5971>] do_mmap_pgoff+0x321/0x39b
>  [<ffffffff805037ee>] _cond_resched+0x1c/0x5f
>  [<ffffffff80211715>] sys_mmap+0xf5/0x138
>  [<ffffffff8020c6d2>] tracesys+0xd5/0xda
> ---[ end trace fe959fb2f0473e7c ]---
> tried to kill an mm-less task!
> 
> This showed up several times in some seconds, but then didn't appear
> any more. And it's reproducable in a x86_64 box, but doesn't happen
> in a x86_32 one.
> 
> And this happens both with and without the oops fixing.
> 

It seems this warning itself is not necessary....

-Kame



