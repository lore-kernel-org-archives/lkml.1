Return-Path: <linux-kernel-owner+w=401wt.eu-S938788AbXG1Dnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938788AbXG1Dnn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 23:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935689AbXG1Dnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 23:43:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934872AbXG1Dnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 23:43:32 -0400
Message-ID: <46AABB5B.3030702@redhat.com>
Date: Fri, 27 Jul 2007 23:43:23 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrea Arcangeli <andrea@suse.de>
CC: tim.c.chen@linux.intel.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: pluggable scheduler flamewar thread (was Re: Volanomark slows by
 80% under CFS)
References: <1185573687.19777.44.camel@localhost.localdomain> <46AA8E57.8010105@redhat.com> <20070728005920.GA31622@v2.random>
In-Reply-To: <20070728005920.GA31622@v2.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli wrote:
> On Fri, Jul 27, 2007 at 08:31:19PM -0400, Chris Snook wrote:
>> I think Volanomark is being pretty stupid, and deserves to run slowly, but 
> 
> Indeed, any app doing what volanomark does is pretty inefficient.
> 
> But this is not the point. I/O schedulers are pluggable to help for
> inefficient apps too. If apps would be extremely smart they would all
> use async-io for their reads, and there wouldn't be the need of
> anticipatory scheduler just for an example.

I'm pretty sure the point of posting a patch that triples CFS performance on a 
certain benchmark and arguably improves the semantics of sched_yield was to 
improve CFS.  You have a point, but it is a point for a different thread.  I 
have taken the liberty of starting this thread for you.

> The fact is there's no technical explanation for which we're forbidden
> to be able to choose between CFS and O(1) at least at boot time.

Sure there is.  We can run a fully-functional POSIX OS without using any block 
devices at all.  We cannot run a fully-functional POSIX OS without a scheduler. 
  Any feature without which the OS cannot execute userspace code is sufficiently 
primitive that somewhere there is a device on which it will be impossible to 
debug if that feature fails to initialize.  It is quite reasonable to insist on 
only having one implementation of such features in any given kernel build.

Whether or not these alternatives belong in the source tree as config-time 
options is a political question, but preserving boot-time debugging capability 
is a perfectly reasonable technical motivation.

	-- Chris
