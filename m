Return-Path: <linux-kernel-owner+w=401wt.eu-S1761964AbZD3I3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761964AbZD3I3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 04:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761454AbZD3I3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 04:29:04 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55860 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128AbZD3I27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 04:28:59 -0400
Date: Thu, 30 Apr 2009 17:27:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH mmotm] memcg: fix mem_cgroup_update_mapped_file_stat
 oops
Message-Id: <20090430172727.82b1e9d2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090430045240.GA4430@balbir.in.ibm.com>
References: <Pine.LNX.4.64.0904292209550.30874@blonde.anvils>
	<20090430090646.a1443096.kamezawa.hiroyu@jp.fujitsu.com>
	<20090430045240.GA4430@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009 10:22:40 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-30 09:06:46]:
> 
> > On Wed, 29 Apr 2009 22:13:33 +0100 (BST)
> > Hugh Dickins <hugh@veritas.com> wrote:
> > 
> > > CONFIG_SPARSEMEM=y CONFIG_CGROUP_MEM_RES_CTLR=y cgroup_disable=memory
> > > bootup is oopsing in mem_cgroup_update_mapped_file_stat().  !SPARSEMEM
> > > is fine because its lookup_page_cgroup() contains an explicit check for
> > > NULL node_page_cgroup, but the SPARSEMEM version was missing a check for
> > > NULL section->page_cgroup.
> > > 
> > Ouch, it's curious this bug alive now.. thank you.
> > 
> > Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > I think this patch itself is sane but.. Balbir, could you see "caller" ?
> > It seems strange.
> 
> Ideally we need to have a disabled check in
> mem_cgroup_update_mapped_file_stat(), but it seems as if this fix is
> better and fixes a larger scenario and the root cause of
> lookup_page_cgroup() OOPSing. It would not hurt to check for
> mem_cgroup_disabled() though, but too many checks might spoil the
> party for frequent operations.
> 
> Kame, do you mean you wanted me to check if I am using
> lookup_page_cgroup() correctly?
> 
Yes. I have no complaints to this patch but just curious.
Anyway thanks.

Regards,
-Kame

