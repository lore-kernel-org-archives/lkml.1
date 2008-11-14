Return-Path: <linux-kernel-owner+w=401wt.eu-S1751959AbYKNKBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbYKNKBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 05:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbYKNKBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 05:01:24 -0500
Received: from mail4.iitk.ac.in ([203.197.196.4]:49097 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbYKNKBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 05:01:23 -0500
Date: Fri, 14 Nov 2008 16:08:06 +0000
From: Rahul Pydimukkala <prahul@cse.iitk.ac.in>
To: Andy Lutomirski <luto@myrealbox.com>
Cc: kyle <kylewong@southa.com>, linux-kernel@vger.kernel.org
Subject: Re: apache threads not balanced over all CPU cores, schedular problem or apache?
Message-ID: <20081114160758.GA4074@csews22.cse.iitk.ac.in>
References: <009401c9454c$6e3a8610$b902a8c0@kyle> <491CF509.7010101@myrealbox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491CF509.7010101@myrealbox.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22:48 Thu 13 Nov     , Andy Lutomirski wrote:
> kyle wrote:

> >top - 12:44:42 up 8 days, 15:45,  7 users,  load average: 2.07, 1.86, 2.02
> >Tasks: 251 total,   1 running, 249 sleeping,   0 stopped,   1 zombie
> >Cpu0  :  0.5%us,  0.5%sy,  0.0%ni, 99.0%id,  0.0%wa,  0.0%hi,  0.0%si,
> >0.0%st
> >Cpu1  : 14.6%us,  4.4%sy,  0.0%ni, 62.6%id, 17.0%wa,  0.0%hi,  1.5%si,
> >0.0%st
> >Cpu2  :  4.3%us,  1.4%sy,  0.0%ni, 93.8%id,  0.0%wa,  0.5%hi,  0.0%si,
> >0.0%st
> >Cpu3  :  0.0%us,  0.0%sy,  0.0%ni, 98.0%id,  2.0%wa,  0.0%hi,  0.0%si,
> >0.0%st
> >Mem:   8117172k total,  8060936k used,    56236k free,   357488k buffers
> >Swap:   208824k total,     8436k used,   200388k free,  5765168k cached
> 
> Looks like you're mostly idle or waiting for I/O.  From this 
> information, it looks like the kernel is probably doing the right thing: 
> keeping a lot of processes that share the same memory and run for very 
> short periods of time on the same cores to minimize cacheline bouncing.
> 
> >
> >All httpd are running on cpu1 and cpu2 only for several hours, after that,
> >all httpd may run on cpu1 and cpu3, or cpu2 and cpu3, etc. again for 
> >several
> >hours.
> >
> >Since the apache is in prefork mode, every httpd instance should be quite
> >independant, I suppose the CPU schedular should balance the processes over
> >the avaiable cores. However never seen httpd processes evenly distributed 
> >to
> >3 cores, or 4 cores.
> 
> Is there any reason to expect it to run faster if it were balanced evenly?

Totally convincing. Thanks Andy for making this clear. I/O-bound processes 
reap no advantage from processor-level parallelism. 

-
Rahul



