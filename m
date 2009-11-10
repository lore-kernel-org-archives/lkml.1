Return-Path: <linux-kernel-owner+w=401wt.eu-S1752825AbZKJIFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbZKJIFB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 03:05:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbZKJIFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 03:05:00 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:37167 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbZKJIFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 03:05:00 -0500
Date: Tue, 10 Nov 2009 17:03:38 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       cl@linux-foundation.org, rientjes@google.com,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [BUGFIX][PATCH] oom-kill: fix NUMA consraint check with
 nodemask v2
Message-Id: <20091110170338.9f3bb417.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20091110164055.a1b44a4b.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091110162121.361B.A69D9226@jp.fujitsu.com>
	<20091110162445.c6db7521.kamezawa.hiroyu@jp.fujitsu.com>
	<20091110163419.361E.A69D9226@jp.fujitsu.com>
	<20091110164055.a1b44a4b.kamezawa.hiroyu@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Nov 2009 16:40:55 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Tue, 10 Nov 2009 16:39:02 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > > > > +
> > > > > +	/* Check this allocation failure is caused by cpuset's wall function */
> > > > > +	for_each_zone_zonelist_nodemask(zone, z, zonelist,
> > > > > +			high_zoneidx, nodemask)
> > > > > +		if (!cpuset_zone_allowed_softwall(zone, gfp_mask))
> > > > >  			return CONSTRAINT_CPUSET;
> > > > 
> > > > If cpuset and MPOL_BIND are both used, Probably CONSTRAINT_MEMORY_POLICY is
> > > > better choice.
> > > 
> > > No. this memory allocation is failed by limitation of cpuset's alloc mask.
> > > Not from mempolicy.
> > 
> > But CONSTRAINT_CPUSET doesn't help to free necessary node memory. It isn't
> > your fault. original code is wrong too. but I hope we should fix it.
> > 
I think so too.

> Hmm, maybe fair enough.
> 
> My 3rd version will use "kill always current(CONSTRAINT_MEMPOLICY does this)
> if it uses mempolicy" logic.
> 
"if it uses mempoicy" ?
You mean "kill allways current if memory allocation has failed by limitation of
cpuset's mask"(i.e. CONSTRAINT_CPUSET case) ?


Thanks,
Daisuke Nishimura.
