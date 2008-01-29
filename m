Return-Path: <linux-kernel-owner+w=401wt.eu-S1764231AbYA2QNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764231AbYA2QNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 11:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763920AbYA2QNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 11:13:22 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47073 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763002AbYA2QNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 11:13:21 -0500
Date: Tue, 29 Jan 2008 21:56:58 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: "Guillaume Chazarain" <guichaz@yahoo.fr>
Cc: "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       a.p.zijlstra@chello.nl, dhaval@linux.vnet.ibm.com
Subject: Re: High wake up latencies with FAIR_USER_SCHED
Message-ID: <20080129162658.GN1044@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <3d8471ca0801271201o5a41955cg552ef06a2f821285@mail.gmail.com> <20080128023129.GD1044@linux.vnet.ibm.com> <3d8471ca0801280857m2ea8518ds2ad8d5346f756a0e@mail.gmail.com> <3d8471ca0801281213l5ec62984i763afb22216cb423@mail.gmail.com> <20080129054742.GA7902@linux.vnet.ibm.com> <3d8471ca0801290753j481c658bud39c541128f3f005@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d8471ca0801290753j481c658bud39c541128f3f005@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 04:53:56PM +0100, Guillaume Chazarain wrote:
> I just thought about something to restore low latencies with
> FAIR_GROUP_SCHED, but it's possibly utter nonsense, so bear with me
> ;-) The idea would be to reverse the trees upside down. The scheduler
> would only see tasks (on the leaves) so could apply its interactivity
> magic, but the hierarchical groups would be used to compute dynamic
> loads for each task according to their position in the tree:

I think this is equivalent to flattening the hierarchy? We discussed this a bit 
sometime back [1], but one of its weaknesses is providing strong
partitioning between groups when it comes to ensuring fairness. Ex: imagine a 
group which does a fork-bomb. With the flattened tree, it affects other groups 
more than it would with a 1-level deep hierarchy.

Having said that, I would be interested to hear other solutions that maintain 
this good partitioning b/n groups and still provide good interactivity!

1. http://lkml.org/lkml/2007/5/30/300

> - now:
>   - we schedule each level of the tree starting from the root
> 
> - with my proposition:
>   - we schedule tasks like with !FAIR_GROUP_SCHED, but
> calc_delta_fair() would traverse the tree starting from the leaves to
> compute the dynamic load.

-- 
Regards,
vatsa
