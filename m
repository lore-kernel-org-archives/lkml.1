Return-Path: <linux-kernel-owner+w=401wt.eu-S1752406AbZFEJ47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbZFEJ47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 05:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbZFEJ4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 05:56:50 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:60193 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbZFEJzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 05:55:50 -0400
Date: Fri, 5 Jun 2009 17:55:27 +0800
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>, Avi Kivity <avi@redhat.com>,
       kvm@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: [RFC] CPU hard limits
Message-ID: <20090605095527.GM11755@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090604053649.GA3701@in.ibm.com> <6599ad830906050153i1afd104fqe70f681317349142@mail.gmail.com> <20090605093625.GI11755@balbir.in.ibm.com> <6599ad830906050248m2c569e5bx44fb3bbddf46f8b1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <6599ad830906050248m2c569e5bx44fb3bbddf46f8b1@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* menage@google.com <menage@google.com> [2009-06-05 02:48:36]:

> On Fri, Jun 5, 2009 at 2:36 AM, Balbir Singh<balbir@linux.vnet.ibm.com> wrote:
> >
> > The important scenario I have is adding and removing groups.
> >
> > Consider 10 cgroups with shares of 10 each, what if 5 new are created
> > with the same shares? We now start getting 100/15, even though we did
> > not change our shares.
> 
> Are you assuming that arbitrary users can create new cgroups whenever
> they like, with whatever shares they like? In that situation, how
> would you use hard limits to provide guarantees? Presumably if the
> user could create a cgroup with an arbitrary share, they could create
> one with an arbitrary hard limit too.
>

What about applications running as root, that can create their own
groups? How about multiple instances of the same application started?
Do applications need to know that creating a group will hurt
guarantees provided to others?
 
> Can you explain a bit more about how you're envisaging cgroups being
> created, and how their shares and hard limits would get set? I was
> working on the assumption that (for any sub-tree of the CFS hierarchy)
> there's a single managing entity that gets to decide the shares given
> to the cgroups within that tree. That managing entity would be
> responsible for ensuring that the shares given out allowed guarantees
> to be met (or alternatively, that the probability of violating those
> guarantees based on the shares given out was within some tolerance
> threshold).
>

The point is that there is no single control entity for creating
groups. if run a solution, it might create groups without telling the
user. No one is arbitrating, not even libcgroup. What if someone
changes the cpuset assignment and moves CPUS x to y in an exclusive
cpuset all of a sudden. How do we arbitrate?

 
-- 
	Balbir
