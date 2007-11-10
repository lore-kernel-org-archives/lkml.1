Return-Path: <linux-kernel-owner+w=401wt.eu-S1759517AbXKJALQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517AbXKJALQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 19:11:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbXKJALE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 19:11:04 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:43534 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750941AbXKJALD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 19:11:03 -0500
Date: Fri, 9 Nov 2007 16:11:03 -0800
From: Micah Dowty <micah@vmware.com>
To: Cyrus Massoumi <cyrusm@gmx.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: High priority tasks break SMP balancer?
Message-ID: <20071110001103.GD16250@vmware.com>
References: <20071109223417.GB16250@vmware.com> <4734F397.7080802@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4734F397.7080802@gmx.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2007 at 12:56:07AM +0100, Cyrus Massoumi wrote:
> I tried your program on my machine (C2D, 2.6.17, O(1) scheduler).
>
> Both CPUs are 100% busy all the time. Each busy-looping thread is running 
> on its own CPU. I've been watching top output for 10 minutes, the spreading 
> is stable and the threads don't bounce at all.

As I said, YMMV. I haven't been able to find a single set of
parameters for the demo program which cause the problem to occur 100%
of the time on all systems.

In general, boosting the MAINTHREAD_PRIORITY even more and increasing
the WAKE_HZ should exaggerate the problem. These parameters reproduce
the problem very reliably on my system:

#define NUM_BUSY_THREADS            2
#define MAINTHREAD_PRIORITY       -20
#define MAINTHREAD_WAKE_HZ       1024
#define MAINTHREAD_LOAD_PERCENT     5
#define MAINTHREAD_LOAD_CYCLES      2

It's also possible this problem doesn't occur on 2.6.17. I have only
tested this example on 2.6.23.1 and 2.6.20 so far.

Thanks,
--Micah
