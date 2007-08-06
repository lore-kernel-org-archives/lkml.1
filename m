Return-Path: <linux-kernel-owner+w=401wt.eu-S1766003AbXHFS2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766003AbXHFS2B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbXHFS1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:27:54 -0400
Received: from mail.gmx.net ([213.165.64.20]:37242 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752325AbXHFS1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:27:53 -0400
X-Authenticated: #4463548
X-Provags-ID: V01U2FsdGVkX184rtEvcm84slhmZWOM678gRDC+E2efweXHn5m8wT
	kzBKmjThc9SgoD
Message-ID: <46B7763C.9030208@gmx.net>
Date: Mon, 06 Aug 2007 21:27:56 +0200
From: Dimitrios Apostolou <jimis@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070301 SeaMonkey/1.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: high system cpu load during intense disk i/o
References: <200708031903.10063.jimis@gmx.net>	<200708051903.12414.jimis@gmx.net>	<20070805182811.a8992126.akpm@linux-foundation.org>	<46B72E2E.5040906@gmx.net> <20070806103317.5688d6df.akpm@linux-foundation.org>
In-Reply-To: <20070806103317.5688d6df.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andrew Morton wrote:
> I suspect I was fooled by the oprofile output, which showed tremendous
> amounts of load in schedule() and switch_to().  The percentages which
> opreport shows are the percentage of non-halted CPU time.  So if you have a
> function in the kernel which is using 1% of the total CPU, and the CPU is
> halted for 95% of the time, it appears that the function is taking 20% of
> CPU!
> 
> The fix for that is to boot with the "idle=poll" boot parameter, to make
> the CPU spin when it has nothing else to do.

I'll test again the two_discs_bad situation after booting with that 
parameter. Thanks.

> 
> I'm suspecting that your machine is just stuck in D state waiting for disk.
>  Did we have a sysrq-T trace? 

The amazing thing is that this doesn't happen! Every single cron jobs 
that keeps running  (I intentionally said that before too) and never 
ends is in R state. By strace'ing the processes they just seem to be 
going *extremely* slow. I also changed the I/O elevator of hdb (the OS 
disk) to deadline from cfq, unfortunately with no results. That is why I 
've been considering it a CPU scheduler issue.


Dimitris
