Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157AbXDMC5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbXDMC5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 22:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbXDMC5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 22:57:49 -0400
Received: from ns.theshore.net ([67.18.92.50]:50959 "EHLO www.theshore.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbXDMC5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 22:57:48 -0400
Message-ID: <461EF1A1.3070102@theshore.net>
Date: Thu, 12 Apr 2007 22:57:37 -0400
From: "Christopher S. Aker" <caker@theshore.net>
User-Agent: Thunderbird 1.5.0.10 (Macintosh/20070221)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Andi Kleen <andi@firstfloor.org>,
       "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [Feature Request?] Inline compression of process core dumps
References: <461E55C6.1030905@theshore.net>	<20070412172845.58bfeff5@the-village.bc.nu>	<20070412164251.GC11736@ti88.telemetry-investments.com>	<p73ps697agf.fsf@bingen.suse.de>	<461EE95A.3090600@theshore.net> <20070412193838.ea98238b.randy.dunlap@oracle.com>
In-Reply-To: <20070412193838.ea98238b.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Thu, 12 Apr 2007 22:22:18 -0400 Christopher S. Aker wrote:
> 
>> Alan Cox wrote:
>>  > Indeed. So useful that in current kernels you can set the core dump
>>  > path to be
>>  >
>>  > 	"|application"
>>
>> Cool stuff!  However, it's not working (2.6.20.6):
>>
>> 	Core dump to |/home/caker/bin/dumper.pl.4442 pipe failed
>>
>> even though...
>>
>> 	# cat /proc/sys/kernel/core_uses_pid
>> 	0
>> 	# cat /proc/sys/kernel/core_pattern
>> 	|/home/caker/bin/dumper.pl
>>
>> Looking at the code, it seems to me that format_corename() is appending 
>> .pid, regardless if !core_uses_pid and corename[0]=='|', in which case 
>> it creates an invalid path for call_usermodehelper_pipe().
>>
>> Bug in the code, or bug in my methods?
> 
> What are you trying to dump?  is it a multi-thread group app,
> not a "simple" app?  I ask because of this (I'm looking at 2.6.21-rc6)
> <mm_users> reference (not that I know what that is):
> 
> 	if (!pid_in_pattern
>             && (core_uses_pid || atomic_read(&current->mm->mm_users) != 1)) {
> 		rc = snprintf(out_ptr, out_end - out_ptr,
> 			      ".%d", current->tgid);
> 		if (rc > out_end - out_ptr)
> 			goto out;
> 		out_ptr += rc;
> 	}

I saw that too, and unfortunately I don't know what what that condition 
represents, either.  It's the only other element in that if statement 
that could make it take that path, so I'm assuming that's part of the 
problem.

The process is a UML instance (skas mode, so at least a kernel, 
userspace, and io thread), which will generate a single, usable, core 
file just fine with a non-pipe core_pattern...

-Chris

