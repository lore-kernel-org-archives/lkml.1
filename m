Return-Path: <linux-kernel-owner+w=401wt.eu-S1759356AbYDNHCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356AbYDNHCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 03:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755316AbYDNHCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 03:02:40 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:57730 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068AbYDNHCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 03:02:40 -0400
Date: Mon, 14 Apr 2008 09:02:34 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Gautham Shenoy <ego@in.ibm.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc9 -- INFO: possible circular locking dependency
	detected
Message-ID: <20080414070234.GA7482@osiris.boeblingen.de.ibm.com>
References: <a44ae5cd0804132004v2bef54fek6e9634f8bce087ab@mail.gmail.com> <1208156045.7427.16.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208156045.7427.16.camel@twins>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 08:54:05AM +0200, Peter Zijlstra wrote:
> Fun,
> 
> I will need to sort out this code before I can say anything about that,
> perhaps Gautham and or Rafael have ideas before I can come up with
> something.. ?

Why not simply removing the get/put_online_cpus() pair in sched_getaffinity?
It's superfluous since we have already a read_lock/read_unlock pair there
which does disable/enable cpu hotplug anyway.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/sched.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -4873,7 +4873,6 @@ long sched_getaffinity(pid_t pid, cpumas
 	struct task_struct *p;
 	int retval;
 
-	get_online_cpus();
 	read_lock(&tasklist_lock);
 
 	retval = -ESRCH;
@@ -4889,8 +4888,6 @@ long sched_getaffinity(pid_t pid, cpumas
 
 out_unlock:
 	read_unlock(&tasklist_lock);
-	put_online_cpus();
-
 	return retval;
 }
 
