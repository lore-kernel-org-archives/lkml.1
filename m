Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbYGKNMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbYGKNMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbYGKNM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:12:27 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:45904 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751622AbYGKNM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:12:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgcFACH4dkhMQWVt/2dsb2JhbACBWq4C
Date: Fri, 11 Jul 2008 09:12:21 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Max Krasnyansky <maxk@qualcomm.com>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 2/3] stop_machine: simplify
Message-ID: <20080711131220.GA7589@Krystal>
References: <200807081750.55536.rusty@rustcorp.com.au> <200807081756.47140.rusty@rustcorp.com.au> <4875582D.4040901@qualcomm.com> <200807111751.14728.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200807111751.14728.rusty@rustcorp.com.au>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:09:20 up 36 days, 17:50,  4 users,  load average: 1.72, 1.82,
	1.78
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell (rusty@rustcorp.com.au) wrote:
> On Thursday 10 July 2008 10:30:37 Max Krasnyansky wrote:
> > Rusty Russell wrote:
> > > stop_machine creates a kthread which creates kernel threads.  We can
> > > create those threads directly and simplify things a little.  Some care
> > > must be taken with CPU hotunplug, which has special needs, but that code
> > > seems more robust than it was in the past.
> > >
> > > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> >
> > Rusty,
> >
> > You mentioned (in private conversation) that you were going to add some
> > logic that checks whether CPU is running user-space code and not holding
> > any locks to avoid scheduling stop_machine thread on it. Was it supposed
> > to be part of this patch ?
> >
> > Max
> 
> No... I tried it, and it killed my machine.  I didn't chase it for the moment, 
> but it's on the "experimental" end of my patch queue.
> 
> Will play with it again and report,
> Rusty.
> 

Hrm, I must be missing something, but using the fact that other CPUs are
running in userspace as a guarantee that they are not running within
critical kernel sections seems kind of.. racy ? I'd like to have a look
at this experimental patch : does it inhibit interrupts somehow and/or
does it take control of userspace processes doing system calls at that
precise moment ?

Mathieu

> 
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
