Return-Path: <linux-kernel-owner+w=401wt.eu-S932567AbXCOHcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567AbXCOHcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 03:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932691AbXCOHcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 03:32:24 -0400
Received: from sceptre.pobox.com ([207.106.133.20]:39791 "EHLO
	sceptre.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567AbXCOHcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 03:32:23 -0400
Date: Thu, 15 Mar 2007 02:32:21 -0500
From: Nathan Lynch <ntl@pobox.com>
To: Robin Holt <holt@sgi.com>
Cc: Cliff Wickman <cpw@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] hotplug cpu: migrate a task within its cpuset
Message-ID: <20070315073220.GR18478@localdomain>
References: <20070309193925.B60891B8028@attica.americas.sgi.com> <20070309235859.GA20093@localdomain> <20070315003642.GB7338@lnx-holt.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315003642.GB7338@lnx-holt.americas.sgi.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Holt wrote:
> On Fri, Mar 09, 2007 at 05:58:59PM -0600, Nathan Lynch wrote:
> > Hello-
> > 
> > Cliff Wickman wrote:
> > > This patch would insert a preference to migrate such a task to a cpu within
> > > its cpuset (and set its cpus_allowed to its cpuset).
> > > 
> > > With this patch, migrate the task to:
> > >  1) to any cpu on the same node as the disabled cpu, which is both online
> > >     and among that task's cpus_allowed
> > >  2) to any online cpu within the task's cpuset
> > >  3) to any cpu which is both online and among that task's cpus_allowed
> > 
> > I think I disagree with this change.
> > 
> > The kernel shouldn't have to be any smarter than it already is about
> > moving tasks off an offlined cpu.  The only way case 2) can be reached
> > is if the user has changed a task's cpu affinity.  If the user is
> > sophisticated enough to manipulate tasks' cpu affinity then they can
> > arrange to migrate tasks as they see fit before offlining a cpu.
> 
> You are assuming some sort of interlock between the admin and the user.

Oh, the horror!  ;-)

> While this may be true on your own personal desktop, I don't think you
> can expect this to be true on a development machine shared by hundreds
> of users and admin'd by a group of people.

Actually, I would hope that a large development environment where
users are given fine-grained control over their resource usage would
1) allow interested tasks to register for notification before a
resource is taken away, and 2) that this system of registration and
notification is implemented in userspace.  Use d-bus or something.

> Additionally, ia64 is gaining support for offlining a cpu which is giving
> cache errors.

Okay.  Consider the case where a task's cpuset consists only of threads
or cores that share cache.  Keeping the task in its cpuset when
offlining due to cache errors is exactly the wrong thing to do.

Anyway, it looks to me like task->cpus_allowed should already reflect
task's cpuset (cpuset.c:attach_task calls sched.c:set_cpus_allowed),
so now I'm missing the point of the patch.
