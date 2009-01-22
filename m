Return-Path: <linux-kernel-owner+w=401wt.eu-S1757534AbZAVKOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534AbZAVKOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 05:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbZAVKO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 05:14:27 -0500
Received: from broadrack.ru ([195.178.208.66]:60624 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154AbZAVKO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 05:14:27 -0500
Date: Thu, 22 Jan 2009 13:14:24 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: David Rientjes <rientjes@google.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>,
       Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
Message-ID: <20090122101424.GA12317@ioremap.net>
References: <200901211638.23101.knikanth@suse.de> <200901212054.34929.knikanth@suse.de> <alpine.DEB.2.00.0901211241040.21080@chino.kir.corp.google.com> <200901221042.30957.knikanth@suse.de> <alpine.DEB.2.00.0901220036440.28850@chino.kir.corp.google.com> <20090122095026.GA10579@ioremap.net> <alpine.DEB.2.00.0901220156310.1738@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0901220156310.1738@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 02:00:55AM -0800, David Rientjes (rientjes@google.com) wrote:
> 
> In an exclusive cpuset, a task's memory is restricted to a set of mems 
> that the administrator has designated.  If it is oom, the kernel must free 
> memory on those nodes or the next allocation will again trigger an oom 
> (leading to a needlessly killed task that was in a disjoint cpuset).
> 
> Really.

The whole point of oom-killer is to kill the most appropriate task to
free the memory. And while task is selected system-wide and some
tunables are added to tweak the behaviour local to some subsystems, this
cpuset feature is hardcoded into the selection algorithm.
And when some tunable starts doing own calculation, behaviour of this
hardcoded feature changes.

This is intended to change it. Because admin has to have ability to tune
system the way he needs and not some special hueristics, which may not
work all the time.

That is the point against cpuset argument. Make it tunable the same way
we have oom_adj and/or this cgroup order feature.

> > In this case administrator will not do this. It is up to him to decide
> > and not some inner kernel policy.
> > 
> 
> Then the scope of this new cgroup is restricted to not being used with 
> cpusets that could oom.

These are perpendicular tasks - cpusets limit one area of the oom
handling, cgroup order - another. Some people needs cpusets, others want
cgroups. cpusets are not something exceptional so that only they have to
be taken into account when doing system-wide operation like OOM
condition handling.

-- 
	Evgeniy Polyakov
