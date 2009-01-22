Return-Path: <linux-kernel-owner+w=401wt.eu-S1757177AbZAVFPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177AbZAVFPU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 00:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbZAVFPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 00:15:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55089 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbZAVFPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 00:15:04 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: David Rientjes <rientjes@google.com>
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
Date: Thu, 22 Jan 2009 10:42:30 +0530
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org
References: <200901211638.23101.knikanth@suse.de> <200901212054.34929.knikanth@suse.de> <alpine.DEB.2.00.0901211241040.21080@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0901211241040.21080@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901221042.30957.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 January 2009 02:19:50 David Rientjes wrote:
> On Wed, 21 Jan 2009, Nikanth Karthikesan wrote:
> > This is a container group based approach to override the oom killer
> > selection without losing all the benefits of the current oom killer
> > heuristics and oom_adj interface.
> >
> > It adds a tunable oom.victim to the oom cgroup. The oom killer will kill
> > the process using the usual badness value but only within the cgroup with
> > the maximum value for oom.victim before killing any process from a cgroup
> > with a lesser oom.victim number. Oom killing could be disabled by setting
> > oom.victim=0.
>
> This doesn't help in memcg or cpuset constrained oom conditions, which
> still go through select_bad_process().
>
> If the oom.victim value is high for a specific cgroup and a memory
> controller oom occurs in a disjoint cgroup, for example, it's possible to
> needlessly kill tasks.  Obviously that is up to the administrator to
> configure, but may not be his or her desire for system-wide oom
> conditions.
>
> It may be preferred to kill tasks in a specific cgroup first when the
> entire system is out of memory or kill tasks within a cgroup attached to a
> memory controller when it is oom.
>
> The same scenario applies for cpuset-constrained ooms.  Since oom.victim
> is given higher preference than all tasks' oom_adj values, it is possible
> to needlessly kill tasks that do not lead to future memory freeing for the
> nodes attached to that cpuset.
>
> It also requires that you synchronize the oom.victim values amongst your
> cgroups.

No, this is not specific to memcg or cpuset cases alone. The same needless 
kills will take place even without memcg or cpuset when an administrator 
specifies a light memory consumer to be killed before a heavy memory user. But 
it is up to the administrator to use it wisely. We also provide a panic_on_oom 
option that an administrator could use, not just to kill few more tasks but 
all tasks in the system ;)

Thanks
Nikanth
