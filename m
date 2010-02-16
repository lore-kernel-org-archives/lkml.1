Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187Ab0BPFZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 00:25:40 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37752 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab0BPFZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 00:25:39 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch 5/7 -mm] oom: replace sysctls with quick mode
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.00.1002151411530.26927@chino.kir.corp.google.com>
References: <20100215170634.729E.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1002151411530.26927@chino.kir.corp.google.com>
Message-Id: <20100216141539.72EF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 16 Feb 2010 14:25:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 15 Feb 2010, KOSAKI Motohiro wrote:
> 
> > > Two VM sysctls, oom dump_tasks and oom_kill_allocating_task, were
> > > implemented for very large systems to avoid excessively long tasklist
> > > scans.  The former suppresses helpful diagnostic messages that are
> > > emitted for each thread group leader that are candidates for oom kill
> > > including their pid, uid, vm size, rss, oom_adj value, and name; this
> > > information is very helpful to users in understanding why a particular
> > > task was chosen for kill over others.  The latter simply kills current,
> > > the task triggering the oom condition, instead of iterating through the
> > > tasklist looking for the worst offender.
> > > 
> > > Both of these sysctls are combined into one for use on the aforementioned
> > > large systems: oom_kill_quick.  This disables the now-default
> > > oom_dump_tasks and kills current whenever the oom killer is called.
> > > 
> > > The oom killer rewrite is the perfect opportunity to combine both sysctls
> > > into one instead of carrying around the others for years to come for
> > > nothing else than legacy purposes.
> > 
> > "_quick" is always bad sysctl name.
> 
> Why?  It does exactly what it says: it kills current without doing an 
> expensive tasklist scan and suppresses the possibly long tasklist dump.  
> That's the oom killer's "quick mode."

Because, an administrator think "_quick" implies "please use it always".
plus, "quick" doesn't describe clealy meanings. oom_dump_tasks does.



> > instead, turnning oom_dump_tasks on
> > by default is better.
> > 
> 
> It's now on by default and can be disabled by enabling oom_kill_quick.
> 
> > plus, this patch makes unnecessary compatibility issue.
> > 
> 
> It's the perfect opportunity when totally rewriting the oom killer to 
> combine two sysctls with the exact same users into one.  Users will notice 
> that the tasklist is always dumped now (we're defaulting oom_dump_tasks 
> to be enabled), so there is no reason why we can't remove oom_dump_tasks, 
> we're just giving them a new way to disable it.  oom_kill_allocating_task 
> no longer always means what it once did: with the mempolicy-constrained 
> oom rewrite, we now iterate the tasklist for such cases to kill a task.  
> So users need to reassess whether this should be set if all tasks on the 
> system are constrained by mempolicies, a typical configuration for 
> extremely large systems.  

No.
Your explanation doesn't answer why this change don't cause any comatibility
issue to _all_ user. Merely "opportunity" doesn't allow we ignore real world user.
I had made some incompatibility patch too, but all one have unavoidable reason. 



