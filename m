Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbZAMBFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbZAMBFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:05:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756130AbZAMBFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:05:43 -0500
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:39790 "EHLO
	QMTA10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752583AbZAMBFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:05:42 -0500
Message-ID: <496BE8F6.1040308@xyzw.org>
Date: Mon, 12 Jan 2009 17:05:58 -0800
From: Brian Rogers <brian@xyzw.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [BUG] How to get real-time priority using idle priority
References: <4969D0D7.2060401@xyzw.org> <1231736941.6003.7.camel@marge.simson.net> <1231765433.5789.35.camel@marge.simson.net> <20090112131406.GB670@elte.hu>
In-Reply-To: <20090112131406.GB670@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> i've applied your fix to tip/sched/urgent and merged it into tip/master.
> Brian, you might want to test tip/master, as per:
>
>  http://people.redhat.com/mingo/tip.git/README
>
> which now has this fix included. Can you make it break?
>   
Yeah, I was able to trigger the same freeze again once on my desktop, 
but it appears to be harder to trigger now. I couldn't get my program to 
freeze the system, but one of the times I suspended then resumed BOINC, 
it happened.

While experimenting on my laptop, things got into a funny state where 
konsole froze, then gnome-terminal froze, so I just started launching 
xterms. pgrep and pidof would freeze and never terminate. ps axl froze 
after listing process 23681, which was a BOINC process. The next 
process, 23682, was another BOINC process. Going into /proc/23682 and 
running ls -l as root froze the shell. I figured out that ls -l exe was 
enough to freeze it. I couldn't shut down BOINC because process 23682 
wouldn't close, and kill -9 did nothing to it. top, which actually did 
work, showed that process just continuing to run with around 100% CPU 
time. I had to power cycle the system.

I'll try Mike's "more complete" patch on top of 2.6.29-rc1 and see what 
that does.

