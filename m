Return-Path: <linux-kernel-owner+w=401wt.eu-S1755150AbXLWIu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbXLWIu1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 03:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbXLWIuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 03:50:15 -0500
Received: from mail.gmx.net ([213.165.64.20]:59967 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751007AbXLWIuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 03:50:14 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18FwolNPuAFxm7fv1p4UtNx5hdpLTOhGakn+cTf/y
	iK5+bolw7N+psg
Subject: Re: [PATCH] kthread: run kthreadd with max priority SCHED_FIFO
From: Mike Galbraith <efault@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jon Masters <jcm@redhat.com>, Michal Schmidt <mschmidt@redhat.com>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
In-Reply-To: <20071222025228.02905a01.akpm@linux-foundation.org>
References: <20071217234314.540b59bd@hammerfall>
	 <20071222013021.db2528cb.akpm@linux-foundation.org>
	 <1198317171.24423.47.camel@perihelion>
	 <1198319970.5509.10.camel@homer.simson.net>
	 <20071222025228.02905a01.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sun, 23 Dec 2007 09:50:15 +0100
Message-Id: <1198399815.11322.74.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-22 at 02:52 -0800, Andrew Morton wrote:
> On Sat, 22 Dec 2007 11:39:30 +0100 Mike Galbraith <efault@gmx.de> wrote:
> 
> > 
> > On Sat, 2007-12-22 at 04:52 -0500, Jon Masters wrote:
> > 
> > > So, user tasks running with SCHED_FIFO should be able to lock a system?
> > > I guess I see both sides of this argument - yes, it's userspace at
> > > fault, but in other cases when userspace is at fault, we take action
> > > (OOM, segfault, others). Isn't this situation just another case where
> > > the kernel needs to avoid the evils of userland going awry?
> > 
> > FYI, Ingo queued the below.
> > 
> > http://lkml.org/lkml/2007/10/31/344
> > 
> 
> That's pretty different of course, but rlimit might be a suitable interface
> for implementing RLIMIT_MAX_CONTINUOUS_RT_MILLISECONDS.

I'd extend Peter's rt safety net instead: mark for forced requeue when
the soft limit is hit, or add that as an intermediate stage.  Possibly
add a demotion stage as well.  I wouldn't try to select lower priority
tasks, which RLIMIT_MAX_CONTINUOUS_RT_MILLISECONDS implies to me.

	-Mike

