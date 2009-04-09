Return-Path: <linux-kernel-owner+w=401wt.eu-S1759163AbZDIBD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759163AbZDIBD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 21:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755808AbZDIBDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 21:03:17 -0400
Received: from mail.crca.org.au ([67.207.131.56]:37794 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813AbZDIBDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 21:03:16 -0400
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Apr 2009 21:03:16 EDT
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [PATCH/RFC] do not count frozen tasks toward load
From: Nigel Cunningham <ncunningham-lkml@crca.org.au>
Reply-To: ncunningham-lkml@crca.org.au
To: Nathan Lynch <ntl@pobox.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       linux-pm@lists.linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Helsley <matthltc@us.ibm.com>
In-Reply-To: <20090408194512.47a99b95@manatee.lan>
References: <20090408194512.47a99b95@manatee.lan>
Content-Type: text/plain
Date: Thu, 09 Apr 2009 10:56:07 +1000
Message-Id: <1239238567.14883.2.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, 2009-04-08 at 19:45 -0500, Nathan Lynch wrote:
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

Sounds great to me - TuxOnIce has had code to save and restore the load
average for ages because of the same issue. This is much better because
it gets to the root of the problem.

I'll apply it here, give it a test and hopefully give you an Acked-by
shortly.

Regards,

Nigel

