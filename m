Return-Path: <linux-kernel-owner+w=401wt.eu-S1752152AbZKJHn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152AbZKJHn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 02:43:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbZKJHn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 02:43:28 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53931 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbZKJHn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 02:43:27 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 10 Nov 2009 16:40:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       cl@linux-foundation.org, rientjes@google.com
Subject: Re: [BUGFIX][PATCH] oom-kill: fix NUMA consraint check with
 nodemask v2
Message-Id: <20091110164055.a1b44a4b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091110163419.361E.A69D9226@jp.fujitsu.com>
References: <20091110162121.361B.A69D9226@jp.fujitsu.com>
	<20091110162445.c6db7521.kamezawa.hiroyu@jp.fujitsu.com>
	<20091110163419.361E.A69D9226@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Nov 2009 16:39:02 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > > > +
> > > > +	/* Check this allocation failure is caused by cpuset's wall function */
> > > > +	for_each_zone_zonelist_nodemask(zone, z, zonelist,
> > > > +			high_zoneidx, nodemask)
> > > > +		if (!cpuset_zone_allowed_softwall(zone, gfp_mask))
> > > >  			return CONSTRAINT_CPUSET;
> > > 
> > > If cpuset and MPOL_BIND are both used, Probably CONSTRAINT_MEMORY_POLICY is
> > > better choice.
> > 
> > No. this memory allocation is failed by limitation of cpuset's alloc mask.
> > Not from mempolicy.
> 
> But CONSTRAINT_CPUSET doesn't help to free necessary node memory. It isn't
> your fault. original code is wrong too. but I hope we should fix it.
> 
Hmm, maybe fair enough.

My 3rd version will use "kill always current(CONSTRAINT_MEMPOLICY does this)
if it uses mempolicy" logic.

Objections ?

Thanks,
-Kame

