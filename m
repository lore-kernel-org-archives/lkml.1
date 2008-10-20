Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbYJTXC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbYJTXC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 19:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755159AbYJTXCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 19:02:44 -0400
Received: from zrtps0kn.nortel.com ([47.140.192.55]:56447 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133AbYJTXCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 19:02:43 -0400
Message-ID: <48FD0DF0.2050008@nortel.com>
Date: Mon, 20 Oct 2008 17:02:08 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: david@lang.hm
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: sched_yield() options
References: <alpine.DEB.1.10.0810201531010.21749@asgard.lang.hm>
In-Reply-To: <alpine.DEB.1.10.0810201531010.21749@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Oct 2008 23:02:09.0361 (UTC) FILETIME=[E13FC410:01C93307]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> I've seen a lot of discussion about how sched_yield is abused by 
> applications. I'm working with a developer on one application that looks 
> like it's falling into this same trap (mutexes between threads and using 
> sched_yield (or more precisely pthread_yield()) to let other threads get 
> the lock)
> 
> however I've been having a hard time tracking down the appropriate 
> discussions to forward on to the developer (both for why what he's doing 
> is bad, and for what he should be doing instead)
> 
> could someone point out appropriate mailing list threads, or other 
> documentation for this?

The main reason why it's bad is that the behaviour of yield() for 
SCHED_OTHER tasks is not strongly defined in the spec.  Depending on 
OS/version you may yield to all other SCHED_OTHER tasks, only one task, 
or anywhere in between.

Also, yield() gives the kernel no information on why it's yielding and 
to whom, so it is impossible for the kernel to make the optimal decision 
in all cases.

For more information, try searching the linux.kernel google groups 
archive.  There's a thread called "yield API" with some information. 
See also " CFS: some bad numbers with Java/database threading [FIXED]".

Chris
