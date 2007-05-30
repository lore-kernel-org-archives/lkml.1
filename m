Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377AbXE3EIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbXE3EIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 00:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbXE3EIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 00:08:44 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:6699 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbXE3EIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 00:08:43 -0400
Date: Tue, 29 May 2007 22:08:42 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Kernel 2.6.21.3 does not work with 8GB of RAM on Intel 965WH
 motherboards.
In-reply-to: <fa.4kEpre7NAj1mG6fooUMp/WVc8tg@ifi.uio.no>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <465CF8CA.8070009@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.4kEpre7NAj1mG6fooUMp/WVc8tg@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> Short Description of Problem:
> Linux 2.6.21.3 does not run properly with 8GB of ram on the Intel 965WH 
> motherboard.
> 
> Long Description of Problem:
> When I use 8GB of memory on my x86_64 system, CPU-bound processes are VERY
> slow, up to 36x slower than usual.  My temporary fix is force Linux to only
> use 4GB of memory, I am currently using mem=4096M.  I ran memtest86 and the
> memory is fine, not a single error.  I tried the following to mem= 1024, 
> 2048
> 4096 and blank "" to let the kernel use all 8GB of memory.  What is wrong
> with the kernel and how come it cannot use 8GB of memory without slowing 
> down
> all CPU-related processes to a snail-like pace?  There is something 
> horribly
> wrong here.
> 
> Specifications:
> Intel Motherboard: 965WH
> Linux Kernel: 2.6.21.3
> Distribution: Debian Testing x86_64
> GCC: gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)
> Target: x86_64-linux-gnu
> 
> Tests:
> 
> 1. append line = 1024M
> top - 18:28:26 up 1 min,  4 users,  load average: 0.42, 0.17, 0.06
> Tasks: 157 total,   1 running, 156 sleeping,   0 stopped,   0 zombie
> Cpu(s):  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  
> 0.0%st
> Mem:   1027016k total,   964288k used,    62728k free,     1232k buffers
> Swap: 16787768k total,        0k used, 16787768k free,   105168k cached
> ---> STATUS: No problems, box is fine, no lag, etc..
> 
> 2. append line = 2048M
> top - 18:34:23 up 2 min,  2 users,  load average: 0.14, 0.14, 0.05
> Tasks: 147 total,   1 running, 146 sleeping,   0 stopped,   0 zombie
> Cpu(s):  1.7%us,  1.2%sy,  0.4%ni, 95.2%id,  1.5%wa,  0.0%hi,  0.0%si,  
> 0.0%st
> Mem:   2059696k total,   956324k used,  1103372k free,     1232k buffers
> Swap: 16787768k total,        0k used, 16787768k free,   102924k cached
> ---> STATUS: No problems, box is fine, no lag, etc..
> 
> 3. append line = 4096M
> top - 18:37:55 up 1 min,  1 user,  load average: 0.52, 0.19, 0.07
> Tasks: 143 total,   1 running, 142 sleeping,   0 stopped,   0 zombie
> Cpu(s):  2.9%us,  2.2%sy,  0.7%ni, 91.6%id,  2.6%wa,  0.0%hi,  0.0%si,  
> 0.0%st
> Mem:   3339536k total,   949792k used,  2389744k free,     1232k buffers
> Swap: 16787768k total,        0k used, 16787768k free,    99920k cached
> 
> $ time ssh p34 uptime
>  19:00:16 up 1 min,  1 user,  load average: 0.67, 0.18, 0.06
> real    0m0.159s
> user    0m0.013s
> sys     0m0.003s
> ---> STATUS: No problems, box is fine, no lag, etc..
> 
> 4. append line = "" (use all 8GB)
> 
> top - 18:52:50 up 9 min,  1 user,  load average: 2.88, 2.43, 1.41
> Tasks: 149 total,   3 running, 146 sleeping,   0 stopped,   0 zombie
> Cpu(s): 36.3%us,  2.2%sy, 10.3%ni, 50.8%id,  0.4%wa,  0.0%hi,  0.1%si,  
> 0.0%st
> Mem:   8104460k total,  1064416k used,  7040044k free,     3296k buffers
> Swap: 16787768k total,        0k used, 16787768k free,   201852k cached
> 
> $ ssh p34
> ssh: connect to host p34 port 22: Connection refused
> 
> Machine takes 5-10 minutes to boot, it acts like a 286 computer, about 8 
> minutes later:
> 
> $ time ssh p34 uptime  # 5 SECONDS!! 36x slower when using 8GB of RAM
>  18:51:39 up 8 min,  1 user,  load average: 2.74, 2.31, 1.30
> 
> real    0m5.757s
> user    0m0.015s
> sys     0m0.004s
> 
> The machine is VERY slow and this is on a gigabit network, I/O does not 
> seem to be affected but rather, CPU-bound processes.
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  2483 root      25   0 25324 5292 1072 R   96  0.1   4:37.12 mailgraph
>  3604 logcheck  30  10  3408 1120  544 R   91  0.0   0:03.55 grep
> 
> These normally take seconds but when I use all 8GB of memory, it runs
> for a very long time.
> 
> Conclusion: For now, I will be using mem=4096M until someone can help me 
> understand what is happening here.  Can anyone offer any insight?
> 
> I found it interesting in make menuconfig on x86_64 there is no 4GB/64GB
> options in the kernel that I remember seeing in 32bit.

That's because that option is not applicable in 64-bit mode.

Can you send your full dmesg output from the 8GB bootup?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

