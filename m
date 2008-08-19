Return-Path: <linux-kernel-owner+w=401wt.eu-S1755998AbYHSRl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbYHSRl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 13:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbYHSRlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 13:41:35 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:37966 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446AbYHSRle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 13:41:34 -0400
Subject: Re: [discuss] memrlimit - potential applications that can use
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: balbir@linux.vnet.ibm.com
Cc: Paul Menage <menage@google.com>, Dave Hansen <haveblue@us.ibm.com>,
       Andrea Righi <righi.andrea@gmail.com>, Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <48AAF8C0.1010806@linux.vnet.ibm.com>
References: <48AA73B5.7010302@linux.vnet.ibm.com>
	 <1219161525.23641.125.camel@nimitz>  <48AAF8C0.1010806@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 19 Aug 2008 10:41:09 -0700
Message-Id: <1219167669.23641.156.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-19 at 22:15 +0530, Balbir Singh wrote:
> Dave Hansen wrote:
> > On Tue, 2008-08-19 at 12:48 +0530, Balbir Singh wrote:
> >> 1. To provide a soft landing mechanism for applications that exceed their memory
> >> limit. Currently in the memory resource controller, we swap and on failure OOM.
> >> 2. To provide a mechanism similar to memory overcommit for control groups.
> >> Overcommit has finer accounting, we just account for virtual address space usage.
> >> 3. Vserver will directly be able to port over on top of memrlimit (their address
> >> space limitation feature)
> > 
> > Balbir,
> > 
> > This all seems like a little bit too much hand waving to me.  I don't
> 
> Dave, there is no hand waving, just an honest discussion. Although, you may not
> see it in the background, we still need overcommit protection and we have it
> enabled by default for the system. There are applications that can deal with the
> constraints setup by the administrator and constraints of the environment,
> please see http://en.wikipedia.org/wiki/Autonomic_computing.

OK, let's get back to describing the basic problem here.  What is the
basic problem being solved?  Applications basically want to get a
failure back from malloc() when the machine is (nearly?) out of memory
so they can stop consuming?

Is this the only way to do autonomic computing with memory?  Or, are
there other or better approaches?

Surely an autonomic computing app could keep track of its own memory
footprint.  

> > really see a single concrete user in the "potential applications" here.
> > I really don't understand why you're pushing this so hard if you don't
> > have anyone to actually use it.
> > 
> > I just don't see anyone that *needs* it.  There's a lot of "it would be
> > nice", but no "needs".
> 
> If you see the original email, I've sent - I've mentioned that we need
> overcommit support (either via memrlimit or by porting over the overcommit
> feature) and the exploiters you are looking for is the same as the ones who need
> overcommit and RLIMIT_AS support.
> 
> On the memory overcommit front, please see PostgreSQL Server Administrator's
> Guide at
> http://www.network-theory.co.uk/docs/postgresql/vol3/LinuxMemoryOvercommit.html
> 
> The guide discusses turning off memory overcommit so that the database is never
> OOM killed, how do we provide these guarantees for a particular control group?
> We can do it system wide, but ideally we want the control point to be per
> control group.

Heh.  That suggestion is, at best, working around a kernel bug.  The DB
guys are just saying to do that because they're the biggest memory users
and always seem to get OOM killed first.

The base problem here is the OOM killer, not an application that truly
uses memory overcommit restriction in an interesting way.

> As far as other users are concerned, I've listed users of the memory limit
> feature, in the original email I sent out. To try and understand your viewpoint
> better, could you please tell me if
> 
> 1. You are opposed to overcommit and RLIMIT_AS as features
> 
> OR
> 
> 2. Expanding them to control groups

I think that too many of the users of (1) probably fall into the
PostgreSQL category.  They found that turning it on "fixed" their bugs,
but it really just swept them under the rug.

So, before we expand the use of those features to control groups by
adding a bunch of new code, let's make sure that there will be users for
it and that those users have no better way of doing it.

-- Dave

