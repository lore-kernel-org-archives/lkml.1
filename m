Return-Path: <linux-kernel-owner+w=401wt.eu-S1759388AbZCBHSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388AbZCBHSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 02:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbZCBHSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 02:18:38 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58598 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229AbZCBHSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 02:18:38 -0500
Date: Mon, 2 Mar 2009 16:17:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, linux-mm@kvack.org,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Bharata B Rao <bharata@in.ibm.com>, Paul Menage <menage@google.com>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] Memory controller soft limit patches (v3)
Message-Id: <20090302161708.beae2dd6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090302160602.521928a5.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090301062959.31557.31079.sendpatchset@localhost.localdomain>
	<20090302092404.1439d2a6.kamezawa.hiroyu@jp.fujitsu.com>
	<20090302044043.GC11421@balbir.in.ibm.com>
	<20090302143250.f47758f9.kamezawa.hiroyu@jp.fujitsu.com>
	<20090302060519.GG11421@balbir.in.ibm.com>
	<20090302152128.e74f51ef.kamezawa.hiroyu@jp.fujitsu.com>
	<20090302063649.GJ11421@balbir.in.ibm.com>
	<20090302160602.521928a5.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Mar 2009 16:06:02 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>  Considering above 2, it's not bad to find victim by proper logic
>  from balance_pgdat() by using mem_cgroup_select_victim().
>  like this:
> ==
>  struct mem_cgroup *select_vicitim_at_soft_limit_via_balance_pgdat(int nid, int zid)
>  {
>      while (?) {
>         vitcim = mem_cgroup_select_victim(init_mem_cgroup);  #need some modification.

Another choice is that when a user set soft-limit via interface, add it to
our own private list and scan it here. (of course, remove at rmdir.)

Thanks,
-Kame

