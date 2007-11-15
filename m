Return-Path: <linux-kernel-owner+w=401wt.eu-S932474AbXKOStS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474AbXKOStS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 13:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764083AbXKOStE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 13:49:04 -0500
Received: from smtpoutm.mac.com ([17.148.16.76]:60752 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764441AbXKOStC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 13:49:02 -0500
In-Reply-To: <20071110001103.GD16250@vmware.com>
References: <20071109223417.GB16250@vmware.com> <4734F397.7080802@gmx.net> <20071110001103.GD16250@vmware.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <2FAA6826-653E-482F-A037-C539BAEEA1DA@mac.com>
Cc: Cyrus Massoumi <cyrusm@gmx.net>,
       LKML Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, Mike Galbraith <efault@gmx.de>,
       Paul Menage <menage@google.com>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: High priority tasks break SMP balancer?
Date: Thu, 15 Nov 2007 13:48:20 -0500
To: Micah Dowty <micah@vmware.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

First of all, since Ingo Molnar seems to be one of the head scheduler  
gurus, you might CC him on this.  Also added a couple other useful  
CCs for regression reports.

On Nov 09, 2007, at 19:11:03, Micah Dowty wrote:
> As I said, YMMV. I haven't been able to find a single set of  
> parameters for the demo program which cause the problem to occur  
> 100% of the time on all systems.
>
> In general, boosting the MAINTHREAD_PRIORITY even more and  
> increasing the WAKE_HZ should exaggerate the problem. These  
> parameters reproduce the problem very reliably on my system:
>
> #define NUM_BUSY_THREADS            2
> #define MAINTHREAD_PRIORITY       -20
> #define MAINTHREAD_WAKE_HZ       1024
> #define MAINTHREAD_LOAD_PERCENT     5
> #define MAINTHREAD_LOAD_CYCLES      2

Well from these statistics; if you are requesting wakeups that often  
then it is probably *not* correct to try to move another thread to  
that CPU in the mean-time.  Essentially the migration cost will  
likely far outweigh the advantage of letting it run a little bit of  
extra time, and in addition it will dump out cache from the high- 
priority thread.  As per the description I think that an increased a  
priority and increased WAKE_HZ will certainly cause the "problem" to  
occur more, simply because it reduces the time between wakeups of the  
high-priority process and makes it less helpful to migrate another  
process over to that CPU during the sleep periods.  This will also  
depend on your hardware and possibly other configuration parameters.

I'm not really that much of an expert in this particular area,  
though, so it's entirely possible that one of the above-mentioned  
scheduler head-honchos will poke holes in my argument and give a  
better explanation or a possible patch.

Cheers,
Kyle Moffett

