Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbZFOLKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbZFOLKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 07:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbZFOLKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 07:10:45 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50073 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbZFOLKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 07:10:44 -0400
Subject: Re: [BUGFIX][PATCH] memcg: fix page_cgroup fatal error in FLATMEM
 v2
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: balbir@linux.vnet.ibm.com
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, hannes@cmpxchg.org, torvalds@linux-foundation.org,
       yinghai@kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <4A3270FE.4090602@linux.vnet.ibm.com>
References: <Pine.LNX.4.64.0906110820170.2258@melkki.cs.Helsinki.FI>
	 <4A31C258.2050404@cn.fujitsu.com>
	 <20090612115501.df12a457.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090612124408.721ba2ae.kamezawa.hiroyu@jp.fujitsu.com>
	 <4A31D326.3030206@cn.fujitsu.com>
	 <20090612143429.76ef2357.kamezawa.hiroyu@jp.fujitsu.com>
	 <84144f020906112321x9912476sb42b5d811741e646@mail.gmail.com>
	 <20090612152922.0e7d1221.kamezawa.hiroyu@jp.fujitsu.com>
	 <4A3270FE.4090602@linux.vnet.ibm.com>
Date: Mon, 15 Jun 2009 14:10:45 +0300
Message-Id: <1245064245.23207.28.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 20:45 +0530, Balbir Singh wrote:
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > Now, SLAB is configured in very early stage and it can be used in
> > init routine now.
> > 
> > But replacing alloc_bootmem() in FLAT/DISCONTIGMEM's page_cgroup()
> > initialization breaks the allocation, now.
> > (Works well in SPARSEMEM case...it supports MEMORY_HOTPLUG and
> >  size of page_cgroup is in reasonable size (< 1 << MAX_ORDER.)
> > 
> > This patch revive FLATMEM+memory cgroup by using alloc_bootmem.
> > 
> > In future,
> > We stop to support FLATMEM (if no users) or rewrite codes for flatmem
> > completely.But this will adds more messy codes and overheads.
> > 
> > Changelog: v1->v2
> >  - fixed typos.
> > 
> > Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> > Tested-by: Li Zefan <lizf@cn.fujitsu.com>
> > Reported-by: Li Zefan <lizf@cn.fujitsu.com>
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> I see you've responded already, Thanks!
> 
> The diff is a bit confusing, was Pekka's patch already integrated, in my version
> of mmotm, I don't see the alloc_pages_node() change in my source base.

Yes, my patch hit mainline on Thursday or so and this patch is now in as well.

			Pekka

