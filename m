Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446AbZCUCnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbZCUCnq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 22:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbZCUCni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 22:43:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63660 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbZCUCnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 22:43:37 -0400
Date: Fri, 20 Mar 2009 21:46:39 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>, mingo@elte.hu,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] introduce user_ns inheritance in user-sched
Message-ID: <20090321024639.GB21064@hallyn.com>
References: <20090319211615.GA18383@us.ibm.com> <1237537460.24626.32.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237537460.24626.32.camel@twins>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Peter Zijlstra (peterz@infradead.org):
> On Thu, 2009-03-19 at 16:16 -0500, Serge E. Hallyn wrote:
> > In a kernel compiled with CONFIG_USER_SCHED=y, cpu shares are
> > allocated according to uid.  Shares are specifiable under
> > /sys/kernel/uids/<uid>/
> > 
> > In a kernel compiled with CONFIG_USER_NS=y, clone(2) with the
> > CLONE_NEWUSER flag creates a new user namespace, and the newly
> > cloned task will belong to uid 0 in the new user namespace.
> 
> We seem to be adding more and more stuff for USER_SCHED, is anybody
> actually using that cruft?
> 
> How far along with cgroups are we to fully simulate that behaviour?
> 
> I think if we have a capable cgroup based replacement for USER_SCHED we
> should axe it from the kernel, would save lots of code...

I didn't realize that was the plan.  Using PAM to move users
around cgroups?  If so, then yeah that would simplify quite a bit
of code.   Won't catch all setuid()s of course - I don't know
who uses USER_SCHED and if that would matter.

-serge
