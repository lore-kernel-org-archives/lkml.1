Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506AbYLLTtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbYLLTtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 14:49:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbYLLTti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 14:49:38 -0500
Received: from nauticaltech.com ([64.34.252.43]:60426 "EHLO nauticaltech.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700AbYLLTth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 14:49:37 -0500
Message-ID: <4942BEC0.2070809@nauticaltech.com>
Date: Fri, 12 Dec 2008 11:42:56 -0800
From: Michael Spiegle <mike@nauticaltech.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: bugme-daemon@bugzilla.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [Bugme-new] [Bug 12201] New: long wait in call_usermodehelper()
 / queue_work() / wait_for_completion()
References: <bug-12201-10286@http.bugzilla.kernel.org/> <20081211143758.510b51b6.akpm@linux-foundation.org>
In-Reply-To: <20081211143758.510b51b6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It'd be great if you could test something more recent please.

Will do.  It takes a little bit of time to reproduce, so I'll respond 
now with information from my current kernel and update once the new 
kernel is running.

> Please attach a copy of the config to
> http://bugzilla.kernel.org/show_bug.cgi?id=12201

Done: http://bugzilla.kernel.org/attachment.cgi?id=19263

> Please get sysrq working then get us a task trace, so we can see who is
> sleeping where.  Do this:

Done: http://bugzilla.kernel.org/attachment.cgi?id=19264

I wanted to get the call to /sbin/modprobe in there as well, so I had to 
do it about 10 times before I could catch it.  I also stopped 
unimportant processes on that box to eliminate additional variables.

There is one other variable I didn't mention.  The machine is diskless 
and running on an nfs root.  I have tried to eliminate this variable via 
simple testing (just running /sbin/modprobe at the commandline returns 
instantly), but wanted to mention it.

The box was 100% idle before starting the pilot program and running the 
task trace.  I added gettimeofday() around my socket() call and got 
about 1290000us - 1490000us on average.  Using a socket() call with 
protocol NETLINK_ROUTE returns in about 5us - 8us.  Certain other 
protocol types like NETLINK_FIREWALL also have the same long delay.


Michael Spiegle
mike@nauticaltech.com
