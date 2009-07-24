Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbZGXPur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbZGXPur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 11:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbZGXPuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 11:50:46 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:59916 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbZGXPuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 11:50:46 -0400
Date: Fri, 24 Jul 2009 08:50:41 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Ben Blum <bblum@google.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, serue@us.ibm.com, lizf@cn.fujitsu.com,
       menage@google.com
Subject: Re: [PATCH 5/6] Makes procs file writable to move all threads by
	tgid at once
Message-ID: <20090724155041.GF5878@count0.beaverton.ibm.com>
References: <20090724032033.2463.79256.stgit@hastromil.mtv.corp.google.com> <20090724032200.2463.82408.stgit@hastromil.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090724032200.2463.82408.stgit@hastromil.mtv.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23, 2009 at 08:22:00PM -0700, Ben Blum wrote:
> Makes procs file writable to move all threads by tgid at once
> 
> This patch adds functionality that enables users to move all threads in a
> threadgroup at once to a cgroup by writing the tgid to the 'cgroup.procs'
> file. This current implementation makes use of a rwsem that's taken for
> reading in the fork() path to prevent newly forking threads within the

There is much ado about not taking additional "global locks" in fork()
paths.

* The fork and exit callbacks cgroup_fork() and cgroup_exit(), don't
* (usually) take cgroup_mutex.  These are the two most performance
* critical pieces of code here. 
...

and as I recall cgroup_fork() doesn't ever take cgroup_mutex because it is
so performance critical. Assuming the above comments in kernel/cgroup.c
are correct then this patch adds a performance regression by introducing a
global mutex in the fork path, doesn't it?

Cheers,
	-Matt Helsley
