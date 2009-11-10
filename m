Return-Path: <linux-kernel-owner+w=401wt.eu-S1752016AbZKJHjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbZKJHjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 02:39:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbZKJHjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 02:39:01 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51559 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbZKJHjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 02:39:00 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [BUGFIX][PATCH] oom-kill: fix NUMA consraint check with nodemask v2
Cc: kosaki.motohiro@jp.fujitsu.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       cl@linux-foundation.org, rientjes@google.com
In-Reply-To: <20091110162445.c6db7521.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091110162121.361B.A69D9226@jp.fujitsu.com> <20091110162445.c6db7521.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20091110163419.361E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 10 Nov 2009 16:39:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +
> > > +	/* Check this allocation failure is caused by cpuset's wall function */
> > > +	for_each_zone_zonelist_nodemask(zone, z, zonelist,
> > > +			high_zoneidx, nodemask)
> > > +		if (!cpuset_zone_allowed_softwall(zone, gfp_mask))
> > >  			return CONSTRAINT_CPUSET;
> > 
> > If cpuset and MPOL_BIND are both used, Probably CONSTRAINT_MEMORY_POLICY is
> > better choice.
> 
> No. this memory allocation is failed by limitation of cpuset's alloc mask.
> Not from mempolicy.

But CONSTRAINT_CPUSET doesn't help to free necessary node memory. It isn't
your fault. original code is wrong too. but I hope we should fix it.



