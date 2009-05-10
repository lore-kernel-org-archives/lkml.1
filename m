Return-Path: <linux-kernel-owner+w=401wt.eu-S1754222AbZEJRMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbZEJRMr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 13:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbZEJRMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 13:12:38 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:44633 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbZEJRMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 13:12:37 -0400
Date: Sun, 10 May 2009 19:12:29 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       michael@araneidae.co.uk
Subject: Re: /proc/uptime idle counter remains at 0
Message-ID: <20090510191229.71f43f3c@skybase>
In-Reply-To: <alpine.LSU.2.00.0905090957490.27646@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0905090957490.27646@fbirervta.pbzchgretzou.qr>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 May 2009 10:05:57 +0200 (CEST)
Jan Engelhardt <jengelh@medozas.de> wrote:

> starting from v2.6.28-4930-g79741dd lasting thru at least v2.6.29.1,
> the second field of /proc/uptime always shows 0.00. This happens for
> both the typical i386 (my case) and on an ARM (according to Michael,
> cc'ed).
> 
> From the commit log of 79741dd:
> 
> 	"""The cpu time spent by the idle process actually doing
> 	something is currently accounted as idle time. This is plain
> 	wrong, the architectures that support VIRT_CPU_ACCOUNTING=y
> 	can do better: distinguish between the time spent doing
> 	nothing and the time spent by idle doing work. The first is
> 	accounted with account_idle_time and the second with
> 	account_system_time."""
> 
> Citing Michael from our irc conversation:
> 
> 	"""the writer[committer] [says] that [the] idle process time
> 	isn't really idle time ... but that's all that /proc/uptime
> 	looks at. I guess fs/proc/uptime.c needs to catch up."""
> 
> So, were the updates to uptime.c missed, or do we now live on with
> /proc/uptime constantly having 0?

The second paragraph from git commit 79741dd tells you more about this:

In addition idle time is no more added to the stime of the idle
process. This field now contains the system time of the idle process as
it should be. On systems without VIRT_CPU_ACCOUNTING this will always
be zero as every tick that occurs while idle is running will be
accounted as idle time.

The point is the semantics of the stime field for the idle process. The
stime field used to contain the real system time (cpu really did
something) of the idle process plus the idle time (cpu is stopped).
After the change the field only contains the real system time. Which is
ihmo much more useful, no?

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

