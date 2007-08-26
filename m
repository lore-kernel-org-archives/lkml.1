Return-Path: <linux-kernel-owner+w=401wt.eu-S934849AbXHZAsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934849AbXHZAsS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 20:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765401AbXHZAsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 20:48:11 -0400
Received: from ozlabs.org ([203.10.76.45]:58965 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765238AbXHZAsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 20:48:10 -0400
Subject: Re: [PATCH 1/1] hotplug cpu: migrate a task within its cpuset
From: Rusty Russell <rusty@rustcorp.com.au>
To: ego@in.ibm.com
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Cliff Wickman <cpw@sgi.com>, mingo@elte.hu, vatsa@in.ibm.com,
       pj@sgi.com, linux-kernel@vger.kernel.org, ntl@in.ibm.com,
       Dipankar Sarma <dipankar@in.ibm.com>
In-Reply-To: <20070826001625.GA17962@in.ibm.com>
References: <20070824221806.GA3602@sgi.com>
	 <20070824155455.cc161b61.akpm@linux-foundation.org>
	 <20070825094740.GA106@tv-sign.ru>  <20070826001625.GA17962@in.ibm.com>
Content-Type: text/plain
Date: Sun, 26 Aug 2007 10:47:24 +1000
Message-Id: <1188089244.19877.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-08-26 at 05:46 +0530, Gautham R Shenoy wrote:
> On Sat, Aug 25, 2007 at 01:47:40PM +0400, Oleg Nesterov wrote:
> > Before this patch, process leaves its ->cpuset and migrates to some "random"
> > any_online_cpu(). With this patch it stays within ->cpuset and migrates to
> > CPU 3.
> 
> The decision to bind a task to a specific cpu, was taken by the userspace
> for a reason, which is _unknown_ to the kernel.
> So logically, shouldn't the userspace decide what should be 
> the fate of those exclusive-affined tasks, whose cpu is about to go
> offline? After all, the reason to offline the cpu is, again, unknown to
> the kernel.

Userspace is not monolithic.  If you refuse to take a CPU offline
because a task is affine, then any user can prevent a CPU from going
offline.

You could, perhaps, introduce a "gentle" offline which fails if process
affinity can no longer be met.

Rusty.

