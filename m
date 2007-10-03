Return-Path: <linux-kernel-owner+w=401wt.eu-S1756093AbXJCJzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbXJCJzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 05:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbXJCJzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 05:55:23 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42220 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752136AbXJCJzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 05:55:22 -0400
Date: Wed, 3 Oct 2007 02:55:18 -0700
From: Paul Jackson <pj@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: akpm@linux-foundation.org, menage@google.com, linux-kernel@vger.kernel.org,
       dino@in.ibm.com, cpw@sgi.com, mingo@elte.hu
Subject: Re: [PATCH] cpuset and sched domains: sched_load_balance flag
Message-Id: <20071003025518.7c184905.pj@sgi.com>
In-Reply-To: <200710030209.56879.nickpiggin@yahoo.com.au>
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com>
	<200710022305.23713.nickpiggin@yahoo.com.au>
	<20071002235849.56dbe9fb.pj@sgi.com>
	<200710030209.56879.nickpiggin@yahoo.com.au>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Yeah -- cpusets are hierarchical.  And some of the use cases for
> > which cpusets are designed are hierarchical.
> 
> But partitioning isn't.

Yup.  We've got a square peg and a round hole.  An impedance mismatch.
That's the root cause of this entire wibbling session, in my view.

The essential role of cpusets, cgroups and much other such work of
recent, in my view, is pounding this square peg into that round hole.
In essence, it is fitting the hierarchical structure of the
organizations (corporations, universities and governments) who own big
systems to the flat, system-wide mandates needed to manage a given
computer system.

> > Changing cpusets from single root to multiple roots would be
> > bastardizing it.
> 
> Well OK, if that's your definition. Not very helpful though.

Well, such a change would be rather substantial and undesired,
if those terms help you more.

> > To repeat myself, in some cases, such as batch schedulers running in a
> > subset of the CPUs on a large system, the code that knows some of the
> > needs for load balancing does not have system wide control to mandate
> > hard partitioning.  The batch scheduler can state where it is depending
> > on load balancing being present, and the system administrator can choose
> > or not to turn off load balancing in the top cpuset, thereby granting or
> > not control over load balancing on the CPUs controlled by the batch
> > scheduler to the batch scheduler.
> 
> Why isn't that possible with my approach?

If I understand your approach to the kernel-to-user interface correctly
(sometimes I doubt I do) then your approach expected some user space code
or person or semi-intelligent equivalent to define a flat partition,
which will then be used to determine the sched domains.

In the batch scheduler case, running on a large shared system used
perhaps by several departments, no one entity can do that.  One person,
perhaps the system admin, knows if they want to give complete control
of some big chunk of CPUs to a batch scheduler.  The batch scheduler,
written by someone else far away and long ago, knows which jobs are
actively running on which subsets of the CPUs the batch scheduler is
using.

There is no single monolithic entity on such systems who knows all and
can dictate all details of a single, flat, system-wide partitioning.

The partitioning has to be sythesized from the combined requests of
several user space entities.  That's ok -- this is bread and butter
work for cpusets.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
