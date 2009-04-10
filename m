Return-Path: <linux-kernel-owner+w=401wt.eu-S932818AbZDJJSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818AbZDJJSQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 05:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763731AbZDJJR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 05:17:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38200 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761345AbZDJJRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 05:17:54 -0400
Date: Fri, 10 Apr 2009 11:20:48 +0200
From: Pavel Machek <pavel@ucw.cz>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       matthltc@us.ibm.com, nigel@tuxonice.net, akpm@linux-foundation.org,
       stable@kernel.org, tglx@linutronix.de, ntl@pobox.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] sched: do not count frozen tasks toward load
Message-ID: <20090410092048.GA30093@elf.ucw.cz>
References: <20090408194512.47a99b95@manatee.lan> <tip-e3c8ca8336707062f3f7cb1cd7e6b3c753baccdd@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-e3c8ca8336707062f3f7cb1cd7e6b3c753baccdd@git.kernel.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-04-09 05:39:32, Nathan Lynch wrote:
> Commit-ID:  e3c8ca8336707062f3f7cb1cd7e6b3c753baccdd
> Gitweb:     http://git.kernel.org/tip/e3c8ca8336707062f3f7cb1cd7e6b3c753baccdd
> Author:     Nathan Lynch <ntl@pobox.com>
> AuthorDate: Wed, 8 Apr 2009 19:45:12 -0500
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu, 9 Apr 2009 07:37:02 +0200
> 
> sched: do not count frozen tasks toward load
> 
> Freezing tasks via the cgroup freezer causes the load average to climb
> because the freezer's current implementation puts frozen tasks in
> uninterruptible sleep (D state).
> 
> Some applications which perform job-scheduling functions consult the
> load average when making decisions.  If a cgroup is frozen, the load
> average does not provide a useful measure of the system's utilization
> to such applications.  This is especially inconvenient if the job
> scheduler employs the cgroup freezer as a mechanism for preempting low
> priority jobs.  Contrast this with using SIGSTOP for the same purpose:
> the stopped tasks do not count toward system load.
> 
> Change task_contributes_to_load() to return false if the task is
> frozen.  This results in /proc/loadavg behavior that better meets
> users' expectations.
> 
> Signed-off-by: Nathan Lynch <ntl@pobox.com>
> Acked-by: Andrew Morton <akpm@linux-foundation.org>
> Acked-by: Nigel Cunningham <nigel@tuxonice.net>
> Tested-by: Nigel Cunningham <nigel@tuxonice.net>
> Cc: <stable@kernel.org>
> Cc: containers@lists.linux-foundation.org
> Cc: linux-pm@lists.linux-foundation.org
> Cc: Matt Helsley <matthltc@us.ibm.com>
> LKML-Reference: <20090408194512.47a99b95@manatee.lan>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
