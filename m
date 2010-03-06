Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab0CFDpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 22:45:38 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:57354 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753584Ab0CFDph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 22:45:37 -0500
Message-ID: <4B91CFE0.8000705@vmware.com>
Date: Fri, 05 Mar 2010 19:45:36 -0800
From: Petr Vandrovec <petr@vmware.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090303 SeaMonkey/1.1.15 (Ubuntu-1.1.15+nobinonly-0ubuntu2)
MIME-Version: 1.0
To: Jeff Chua <jeff.tw.chua@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: commit 554f76962d3a6eb5110415f1591aca83f96a84ae hangs USB for
 vmware 7.0.1
References: <Pine.LNX.4.64.1003060606480.6040@boston.corp.fedex.com> <alpine.LFD.2.00.1003051438280.3906@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1003051438280.3906@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sat, 6 Mar 2010, Jeff Chua wrote:
>> Linux version v2.6.33-5399-gcc7889f with reiser3 and vmware-7.0.1
>>
>> Starting vmware just hang even before displaying the main GUI. Reverting
>> 554f76962d3a6eb5110415f1591aca83f96a84ae solves the problem.
>>
>> It seems vmware is trying to access the USB but this commit blocks it.
>>
>> So, is this a vmware problem or shall this be reverted?

Hello,
    does your box hang, or is it just vmware process that is hung?  I've 
noticed that my box here at work has this change too, and I do not see 
any hang - neither in kernel, or in GUI startup, nor in test sample:

open("/proc/bus/usb/devices", O_RDWR)   = 3
poll([{fd=3, events=POLLIN}], 1, 5000)  = 1 ([{fd=3, revents=POLLIN}])
poll([{fd=3, events=POLLIN}], 1, 5000)  = 0 (Timeout)
exit_group(0)                           = ?
petr-dev3:/tmp# uname -a
Linux petr-dev3 2.6.33-64-05079-g6517b45-dirty #51 SMP PREEMPT Thu Mar 4 
20:29:55 PST 2010 x86_64 GNU/Linux

							Petr

[Removed Eli from CC.  He left.]

> 
> It's almost certainly a deadlock through some path that wasn't tested.
> 
> Can you enable lockdep on that kernel when you run vmware, which should 
> give us a nice callchain etc, and hopefully make it very obvious what goes 
> on.
> 
> Reverting it is obviously an option, but with some more info maybe there's 
> a better solution.
> 
> (It may be that the deadlock is obvious to Oliver/Greg even without any 
> lockdep chains, of course, but still worth trying, I suspect)
> 
> 		Linus

