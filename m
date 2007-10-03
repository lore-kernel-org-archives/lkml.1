Return-Path: <linux-kernel-owner+w=401wt.eu-S1758529AbXJCR6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529AbXJCR6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 13:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756054AbXJCR6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 13:58:23 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52377 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755947AbXJCR6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 13:58:23 -0400
Date: Wed, 3 Oct 2007 10:58:17 -0700
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: akpm@linux-foundation.org, nickpiggin@yahoo.com.au, a.p.zijlstra@chello.nl,
       serue@us.ibm.com, clg@fr.ibm.com, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com, rientjes@google.com, svaidy@linux.vnet.ibm.com,
       xemul@openvz.org, containers@lists.osdl.org, balbir@linux.vnet.ibm.com
Subject: Re: [PATCH] task containersv11 add tasks file interface fix for
 cpusets
Message-Id: <20071003105817.7adf6516.pj@sgi.com>
In-Reply-To: <6599ad830710030851jb44f00ft9634f9381218b6e9@mail.gmail.com>
References: <20071003084241.24279.62099.sendpatchset@jackhammer.engr.sgi.com>
	<6599ad830710030851jb44f00ft9634f9381218b6e9@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> > The code in kernel/cgroup.c attach_task() which skips the
> > attachment of a task to the group it is already in has to be
> > removed.  Cpusets depends on reattaching a task to its current
> > cpuset, in order to trigger updating the cpus_allowed mask in the
> > task struct.
> 
> Can you explain a bit more about why this is needed? (i.e. specific
> scenarios where cpusets will break without this change).
> 
> What triggers the reattach in normal use? Something from userspace?

Yes, something in user space has to do it.  It's part of the
kernel-user cpuset API.  If you change a cpuset's 'cpus', then
you have to rewrite each pid in its 'tasks' file back to that
'tasks' file in order to get that 'cpus' change to be applied
to the task struct cpus_allowed of each task, and thereby visible
to the scheduler.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
