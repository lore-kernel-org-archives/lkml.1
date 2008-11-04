Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbYKDGSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbYKDGSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 01:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbYKDGSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 01:18:24 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47585 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbYKDGSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 01:18:23 -0500
Date: Tue, 4 Nov 2008 15:17:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       hugh@veritas.com, taka@valinux.co.jp
Subject: Re: [RFC][PATCH 1/5] memcg : force_empty to do move account
Message-Id: <20081104151748.4731f5a1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830811032215j3ce5dcc1g6d0c3e9439a004d@mail.gmail.com>
References: <20081031115057.6da3dafd.kamezawa.hiroyu@jp.fujitsu.com>
	<20081031115241.1399d605.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830811032215j3ce5dcc1g6d0c3e9439a004d@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Nov 2008 22:15:41 -0800
Paul Menage <menage@google.com> wrote:

> On Thu, Oct 30, 2008 at 6:52 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > This patch provides a function to move account information of a page between
> > mem_cgroups and rewrite force_empty to make use of this.
> 
> One part of this that wasn't clear to me - if a cgroup has a lot of
> unmapped pagecache sitting around but no tasks, and we try to rmdir
> it, then all the pagecache gets moved to the parent too? Or just the
> stray mapped pages?
> 
All page caches will be moved to. 
(I'll add "shrink_usage" interface to drop page caches, later.)

> > @@ -597,7 +709,7 @@ static int mem_cgroup_charge_common(stru
> >        prefetchw(pc);
> >
> >        mem = memcg;
> > -       ret = mem_cgroup_try_charge(mm, gfp_mask, &mem);
> > +       ret = __mem_cgroup_try_charge(mm, gfp_mask, &mem, true);
> 
> Isn't this the same as the definition of mem_cgroup_try_charge()? So
> you could leave it as-is?
> 
try_charge is called by other places....swapin.

Thanks,
-Kame

