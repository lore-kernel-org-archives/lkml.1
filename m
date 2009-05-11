Return-Path: <linux-kernel-owner+w=401wt.eu-S1754533AbZEKIKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbZEKIKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 04:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbZEKIKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 04:10:39 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:36678 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbZEKIKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 04:10:38 -0400
Date: Mon, 11 May 2009 10:10:36 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Michael Abbott <michael@araneidae.co.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Re: /proc/uptime idle counter remains at 0
Message-ID: <20090511101036.5bcb4245@skybase>
In-Reply-To: <alpine.LSU.2.00.0905110938210.667@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0905090957490.27646@fbirervta.pbzchgretzou.qr>
	<20090510191229.71f43f3c@skybase>
	<alpine.LSU.2.00.0905110237310.17675@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0905110656180.6983@venus.araneidae.co.uk>
	<20090511093512.38ba9b70@skybase>
	<alpine.LSU.2.00.0905110938210.667@fbirervta.pbzchgretzou.qr>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009 09:42:03 +0200 (CEST)
Jan Engelhardt <jengelh@medozas.de> wrote:

> 
> On Monday 2009-05-11 09:35, Martin Schwidefsky wrote:
> >> I have to confess I don't really understand the logic of what's going on 
> >> here -- in particular, what does the idle process do other than account 
> >> for time when the processor has nothing useful to do?  It does seem to me 
> >> now that the .utime and .stime fields are now less than useful -- maybe 
> >> they can be deleted now?
> >
> >The idle task does not just sleep, it will do "real" work, e.g. softirq
> >handling for interrupts / network traffic.
> 
> With an RT kernel, SIRQ and such are separate tasks. That should also
> be play a role while 0 is displayed.

With an RT kernel there still is a tiny amount of system work in idle,
that is the instruction executed to switch to the idle process, go to
sleep, wake up again and switch back to another process.

> >> I've always assumed that the second field of /proc/uptime was a simple 
> >> measure of time not spent doing real work, in other words a crude measure 
> >> of spare CPU resources.  My instrument basically uses the the two fields 
> >> of this file to compute a measure of CPU loading so it can raise an alert 
> >> if the CPU doesn't have enough spare (idle) capacity.
> >
> >But it wasn't.. the old style stime of idle is a mixture of true idle
> >time and some system time.
> 
> Then I would say let's show the idle time only (but still inculde
> the idle time when the CPU is halted).

That is hard to do. I've implemented this for s390 where the idle time
really is the time spent waiting. To improve x86 with its tick based
accounting you need to find out if the timer interrupt arrived while
the cpu has been waiting, e.g. check the instruction pointed to by eip
for "hlt".

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

