Return-Path: <linux-kernel-owner+w=401wt.eu-S1753036AbYKNDsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbYKNDsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 22:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbYKNDs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 22:48:26 -0500
Received: from 207-172-69-77.c3-0.smr-ubr3.sbo-smr.ma.static.cable.rcn.com ([207.172.69.77]:53355
	"EHLO thaum.luto.us" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbYKNDs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 22:48:26 -0500
Message-ID: <491CF509.7010101@myrealbox.com>
Date: Thu, 13 Nov 2008 22:48:25 -0500
From: Andy Lutomirski <luto@myrealbox.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: kyle <kylewong@southa.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: apache threads not balanced over all CPU cores, schedular problem
 or apache?
References: <009401c9454c$6e3a8610$b902a8c0@kyle>
In-Reply-To: <009401c9454c$6e3a8610$b902a8c0@kyle>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kyle wrote:
> Hi,
> 
> Please cc me if possible.
> 
> I have a machine with Intel Q9300 4-core CPU, 8GB RAM. It runs apache 2.0.63
> with traditional prefork MPM.
> It's a high traffic site, most of the time there's over 100 httpd processes
> running and at peak hours around 200.
> 
> I found that most of the time, all httpd processes are running at 2 CPU
> cores only, sometime it's cpu0 and cpu1, sometime it's cpu1 and cpu3,
> sometime it's cpu0 and cpu2 ... etc. It may take several hours the processes
> "migrate" from 2 cores to another 2. To make it clear:
> 
> top - 12:44:42 up 8 days, 15:45,  7 users,  load average: 2.07, 1.86, 2.02
> Tasks: 251 total,   1 running, 249 sleeping,   0 stopped,   1 zombie
> Cpu0  :  0.5%us,  0.5%sy,  0.0%ni, 99.0%id,  0.0%wa,  0.0%hi,  0.0%si,
> 0.0%st
> Cpu1  : 14.6%us,  4.4%sy,  0.0%ni, 62.6%id, 17.0%wa,  0.0%hi,  1.5%si,
> 0.0%st
> Cpu2  :  4.3%us,  1.4%sy,  0.0%ni, 93.8%id,  0.0%wa,  0.5%hi,  0.0%si,
> 0.0%st
> Cpu3  :  0.0%us,  0.0%sy,  0.0%ni, 98.0%id,  2.0%wa,  0.0%hi,  0.0%si,
> 0.0%st
> Mem:   8117172k total,  8060936k used,    56236k free,   357488k buffers
> Swap:   208824k total,     8436k used,   200388k free,  5765168k cached

Looks like you're mostly idle or waiting for I/O.  From this 
information, it looks like the kernel is probably doing the right thing: 
keeping a lot of processes that share the same memory and run for very 
short periods of time on the same cores to minimize cacheline bouncing.

> 
> All httpd are running on cpu1 and cpu2 only for several hours, after that,
> all httpd may run on cpu1 and cpu3, or cpu2 and cpu3, etc. again for several
> hours.
> 
> Since the apache is in prefork mode, every httpd instance should be quite
> independant, I suppose the CPU schedular should balance the processes over
> the avaiable cores. However never seen httpd processes evenly distributed to
> 3 cores, or 4 cores.

Is there any reason to expect it to run faster if it were balanced evenly?

--Andy
