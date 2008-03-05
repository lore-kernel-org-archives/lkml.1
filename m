Return-Path: <linux-kernel-owner+w=401wt.eu-S1765436AbYCEKeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765436AbYCEKeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 05:34:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762387AbYCEKd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 05:33:58 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:52773 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758831AbYCEKd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 05:33:57 -0500
Date: Wed, 5 Mar 2008 16:03:43 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>
Cc: fedora-devel-list@redhat.com, opensuse-packaging@opensuse.org,
       lkml <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org, Balbir Singh <balbir@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>
Subject: Re: [RFC] libcg: design and plans
Message-ID: <20080305103343.GA22217@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080304152341.GB5659@linux.vnet.ibm.com> <6599ad830803042215n6aedb3eeub0c037e6a4e7bb34@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830803042215n6aedb3eeub0c037e6a4e7bb34@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 10:15:20PM -0800, Paul Menage wrote:
> Hi Dhaval,
> 
> On Tue, Mar 4, 2008 at 7:23 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> > Hi,
> >
> >  We have been working on a library for control groups which would provide
> >  simple APIs for programmers to utilize from userspace and make use of
> >  control groups.
> >
> >  We are still designing the library and the APIs. I've attached the
> >  design (as of now) to get some feedback from the community whether we
> >  are heading in the correct direction and what else should be addressed.
> 
> There are a few things that it would be nice to include in such a
> library, if you're going to develop one:
> 
> - the ability to create abstract groups of processes, and resource
> groups, and have the ability to tie these together arbitrarily. E.g
> you might create abstract groups A, B and C, and be able to say that A
> and B share memory with each other but not with C, and all three
> groups are isolated from each other for CPU. Then libcg would mount
> different resource types in different cgroup hierarchies (you would
> probably tell it ahead of time which combinations of sharing you would
> want, in order that it could minimize the number of mounted
> hierarchies). When you tell libcg to move a process into abstract
> group A, it would move it into the appropriate resource group in each
> hierarchy.
> 

I am not very clear about what you are asking for here, so let me try to
rephrase it, and if I have understood it correctly, we can move further
ahead from there.

So there are two different points, /mem and /cpu. /mem has A and C and
/cpu has A, B and C. A and B of /cpu correspond to A of /mem and the C's
are the same. With this is mind, if I say a task should move to B in
/cpu, it should also move to A in /mem?

> - an interface for gathering usage stats from cgroups.
> 

Yes, that is a todo. We should get around to it as the functionality
gets implemented in kernel.

> - support for dynamically migrating processes between groups based on
> process connector events (i.e. a finished version of the daemon that
> you were working on last year)
> 

libcg is at a lower level than this. The dynamic migration of processes
can be based on top of libcg, and exploit it (and be more powerful than
the daemon I posted last year) It would be able to utilize the
configuration and other capabilities of libcg.

Thanks,
-- 
regards,
Dhaval
