Return-Path: <linux-kernel-owner+w=401wt.eu-S1759565AbXH1RXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565AbXH1RXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 13:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbXH1RW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 13:22:58 -0400
Received: from ozlabs.org ([203.10.76.45]:57080 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921AbXH1RW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 13:22:56 -0400
Subject: Re: [PATCH 1/1] hotplug cpu: migrate a task within its cpuset
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ego@in.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>,
       Cliff Wickman <cpw@sgi.com>, mingo@elte.hu, vatsa@in.ibm.com,
       pj@sgi.com, linux-kernel@vger.kernel.org, ntl@in.ibm.com,
       Dipankar Sarma <dipankar@in.ibm.com>
In-Reply-To: <20070826010903.7599c22e.akpm@linux-foundation.org>
References: <20070824221806.GA3602@sgi.com>
	 <20070824155455.cc161b61.akpm@linux-foundation.org>
	 <20070825094740.GA106@tv-sign.ru> <20070826001625.GA17962@in.ibm.com>
	 <1188089244.19877.3.camel@localhost.localdomain>
	 <20070826010903.7599c22e.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 27 Aug 2007 17:01:34 +1000
Message-Id: <1188198094.5531.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-08-26 at 01:09 -0700, Andrew Morton wrote:
> On Sun, 26 Aug 2007 10:47:24 +1000 Rusty Russell <rusty@rustcorp.com.au> wrote:
> > Userspace is not monolithic.  If you refuse to take a CPU offline
> > because a task is affine, then any user can prevent a CPU from going
> > offline.
> 
> That's a kernel bug.

You mean "would be if it were implemented"?  Although consider the
equivalent forkbomb or thrashing userspace problems, where we just say
"use quotas".

Just to clarify: that is not how we work, we migrate tasks off a dying
CPU, breaking affinity and printing a warning if necessary.  

It was simple and has not proven problematic in practice.  (Userspace
cpu affinity has been a question of optimality not correctness)

> > You could, perhaps, introduce a "gentle" offline which fails if process
> > affinity can no longer be met.
> 
> Suitably privileged userspace should be able to
> 
> 1) prevent tasks from binding to CPU N then
> 2) migrate all tasks which can use CPU N over to other CPU(s) then
> 3) offline CPU N.

Indeed, (1) is missing.  I would hesitate to introduce more
infrastructure in an under-worn and over-buggy part of the kernel
though.

Rusty.


