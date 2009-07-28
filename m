Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbZG1A1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbZG1A1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 20:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbZG1A1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 20:27:31 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47263 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbZG1A1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 20:27:30 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 28 Jul 2009 09:25:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, miaox@cn.fujitsu.com,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Paul Menage <menage@google.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       y-goto@jp.fujitsu.com, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] set_mempolicy(MPOL_INTERLEAV) cause kernel panic
Message-Id: <20090728092529.bb0d7e9c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.0907271710590.27881@chino.kir.corp.google.com>
References: <20090715182320.39B5.A69D9226@jp.fujitsu.com>
	<1247679064.4089.26.camel@useless.americas.hpqcorp.net>
	<alpine.DEB.2.00.0907161257190.31844@chino.kir.corp.google.com>
	<alpine.DEB.2.00.0907241551070.8573@chino.kir.corp.google.com>
	<20090724160936.a3b8ad29.akpm@linux-foundation.org>
	<337c5d83954b38b14a17f0adf4d357d8.squirrel@webmail-b.css.fujitsu.com>
	<5bb65c0e4c6828b1331d33745f34d9ee.squirrel@webmail-b.css.fujitsu.com>
	<9443f91bd4648e6214b32acff4512b97.squirrel@webmail-b.css.fujitsu.com>
	<alpine.DEB.2.00.0907271047590.8408@chino.kir.corp.google.com>
	<20090728085810.f7ae678a.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0907271710590.27881@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jul 2009 17:14:32 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> On Tue, 28 Jul 2009, KAMEZAWA Hiroyuki wrote:
> 
> > > The nodemask for each task is updated to reflect the removal of a node and 
> > > it calls mpol_rebind_mm() with the new nodemask.
> > > 
> > yes, but _not_ updated at online.
> > 
> 
> Well, I disagreed that we needed to alter any pre-existing mempolicies for 
> MEM_GOING_ONLINE or MEM_ONLINE since it may diverge from the original 
> intent of the policy.  MPOL_PREFERRED certain shouldn't change, 
> MPOL_INTERLEAVE would be unbalanced, and MPOL_BIND could diverge from 
> memory isolation or affinity requirements.
> 
> I'd be interested to hear any real world use cases for MEM_ONLINE updating 
> of mempolicies.
> 
Sorry, I was a bit condused. I thought I said about task->mems_allowed.
Not each policy.

Because we dont' update, task->mems_allowed need to be initilaized as
N_POSSIBLE_NODES. At usual thinking,  it should be N_HIGH_MEMORY or
N_ONLINE_NODES, as my patch does.

> > What I felt at reading cpuset/mempolicy again is that it's too complex ;)
> > The 1st question is why mems_allowed which can be 1024bytes when max_node=4096
> > is copied per tasks....
> 
> The page allocator needs lockless access to mems_allowed.
> 
Hmm, ok, I'll take care of that. 

Thanks,
-Kame

