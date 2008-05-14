Return-Path: <linux-kernel-owner+w=401wt.eu-S1761953AbYENI12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761953AbYENI12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 04:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbYENI1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 04:27:15 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56070 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbYENI1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 04:27:13 -0400
Date: Wed, 14 May 2008 17:32:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "hugh@veritas.com" <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC/PATCH 4/6] memcg: shmem reclaim helper
Message-Id: <20080514173209.860d1c1d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <482AA16D.7060200@cn.fujitsu.com>
References: <20080514170236.23c9ddd7.kamezawa.hiroyu@jp.fujitsu.com>
	<20080514171025.2f0fb1ca.kamezawa.hiroyu@jp.fujitsu.com>
	<482A9FB5.4020202@cn.fujitsu.com>
	<20080514172531.672e0447.kamezawa.hiroyu@jp.fujitsu.com>
	<482AA16D.7060200@cn.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 16:23:09 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > On Wed, 14 May 2008 16:15:49 +0800
> > Li Zefan <lizf@cn.fujitsu.com> wrote:
> > 
> >>> +	while(!progress && --retry) {
> >>> +		progress = try_to_free_mem_cgroup_pages(mem, gfp_mask);
> >>> +	}
> >> This is wrong. How about:
> >> 	do {
> >> 		...
> >> 	} while (!progress && --retry);
> >>
> > Ouch, or retry--....
> > 
> 
> retry-- is still wrong, because then after while, retry will be -1, and then:
> 
> +	if (!retry)
> +		return -ENOMEM;
> 
ok, i'm now rewriting.

Thanks,
-Kame

