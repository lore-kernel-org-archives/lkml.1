Return-Path: <linux-kernel-owner+w=401wt.eu-S1760424AbYGRB2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760424AbYGRB2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 21:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbYGRB2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 21:28:08 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:15503 "EHLO
	pd5mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753903AbYGRB2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 21:28:05 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=uZvujYp8AAAA:8 a=Y9fjpQ4ByRy8a-dx-hIA:9 a=dx7Kl_h-E8p-9gCfC5MA:7 a=gYSbvqL4_bQO3UUwO8ed7sbu3BAA:4
Message-ID: <487FF1A2.8000404@shaw.ca>
Date: Thu, 17 Jul 2008 19:28:02 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: akineko <akineko@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: EINTR under Linux
References: <3f676a38-51a8-4fb6-bf02-c717b21bee06@e39g2000hsf.googlegroups.com>
In-Reply-To: <3f676a38-51a8-4fb6-bf02-c717b21bee06@e39g2000hsf.googlegroups.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akineko wrote:
> Hello,
> 
> I have a socket program that is running flawlessly under Solaris.
> When I re-compiled it under Linux (CentOS 5.1) and run it, I got the
> following error:
> 
> recv() failed: Interrupted system call
> 
> This only occurs very infrequently (probably one out of a million
> packets exchanged).
> 
> select() in my program is getting EINTR.
> 
> From the postings I found in the news group seem suggesting that it is
> due to GC.
> 
>> The GC sends signals to each thread which causes them all to enter a stop-the-world state.  When the GC
>> is finished,  all the threads are resumed.  When the threads are  resumed, any that were blocked in a
>> blocking system call (like poll()) will return with EINTR.  Normally you would just retry the system call.
> 
> So, I added to check if the errno == EINTR and now my program seems
> working fine.
> 
> //
> 
> My question I would like to ask in this group is:
> Does this mean any system call under Linux could return empty-hand
> with EINTR due to GC?
> I usually assume fatal if system call returns -1.
> It is quite painful to check all system-call return status.
> 
> My second question is:
> Does this can occur in other OS's? (free-BSD, Solaris, ...)
> Or, is this specific to Linux OS?

I'm not sure what the GC you're referring to is, but I assume it's using 
a signal handler for that stop signal. If the signal handler is not 
installed with the SA_RESTART flag, then if a system call is interrupted 
by that signal it will get EINTR instead of being restarted 
automatically. For some system calls, EINTR can still occur, for 
example, see:

http://www.opengroup.org/onlinepubs/007908775/xsh/select.html

This is not Linux specific, but the specs allow for some different 
behavior between UNIX variants.
