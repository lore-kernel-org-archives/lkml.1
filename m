Return-Path: <linux-kernel-owner+w=401wt.eu-S1753639AbYKMNGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbYKMNGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 08:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbYKMNGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 08:06:05 -0500
Received: from mail4.iitk.ac.in ([203.197.196.4]:37683 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbYKMNGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 08:06:04 -0500
Date: Thu, 13 Nov 2008 19:12:43 +0000
From: Rahul Pydimukkala <prahul@cse.iitk.ac.in>
To: kyle <kylewong@southa.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: apache threads not balanced over all CPU cores, schedular problem or apache?
Message-ID: <20081113191241.GB14953@csews22.cse.iitk.ac.in>
References: <009401c9454c$6e3a8610$b902a8c0@kyle> <20081113143404.GC12750@csews22.cse.iitk.ac.in> <001f01c94585$799bf280$0a01a8c0@kylecea1512a3f>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001f01c94585$799bf280$0a01a8c0@kylecea1512a3f>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Few of the cores are always left idle by default for power saving reasons.
There has been a discussion over it sometime back. http://lkml.org/lkml/2008/6/25/326 

That helps you play around with the load-balancer.

  

-
Rahul



On 19:46 Thu 13 Nov     , kyle wrote:
> From: "Rahul Pydimukkala" <prahul@cse.iitk.ac.in>
> To: "kyle" <kylewong@southa.com>
> Cc: <linux-kernel@vger.kernel.org>
> Sent: Thursday, November 13, 2008 10:34 PM
> Subject: Re: apache threads not balanced over all CPU cores, schedular 
> problem or apache?
> 
> 
> >On 12:58 Thu 13 Nov     , kyle wrote:
> >>Hi,
> >>
> >>Please cc me if possible.
> >>
> >>I have a machine with Intel Q9300 4-core CPU, 8GB RAM. It runs apache 
> >>2.0.63
> >>with traditional prefork MPM.
> >
> >Yes, this is quite undesirable given that the kernel has a good 
> >load-balancer.  Can you give more information regarding the kernel version 
> >and load stats of individual apache processes as well?
> >-
> >Rahul
> >
> 
> They now all load on cpu1 and cpu2.
> 
> top - 19:35:42 up 8 days, 22:36,  8 users,  load average: 1.77, 1.63, 1.75
> Tasks: 251 total,   2 running, 249 sleeping,   0 stopped,   0 zombie
> Cpu0  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si, 
> 0.0%st
> Cpu1  : 14.1%us,  4.4%sy,  0.0%ni, 52.9%id, 27.2%wa,  0.0%hi,  1.5%si, 
> 0.0%st
> Cpu2  :  4.3%us,  2.9%sy,  0.0%ni, 92.3%id,  0.0%wa,  0.0%hi,  0.5%si, 
> 0.0%st
> Cpu3  :  0.5%us,  0.5%sy,  0.0%ni, 98.0%id,  1.0%wa,  0.0%hi,  0.0%si, 
> 0.0%st
> Mem:   8117172k total,  8029032k used,    88140k free,   373356k buffers
> Swap:   208824k total,     8576k used,   200248k free,  5884936k cached
> 
>  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
> 15112 nobody    20   0  199m  10m 7344 S  2.5  0.1   0:00.94 2 httpd
> 14488 nobody    20   0  208m  17m 8400 S  2.0  0.2   0:02.06 1 httpd
> 15184 nobody    20   0  203m  12m 7652 S  2.0  0.2   0:00.69 1 httpd
> 15320 nobody    20   0  199m 9736 6556 S  2.0  0.1   0:00.29 2 httpd
> 15466 nobody    20   0  201m 9424 4684 S  2.0  0.1   0:00.05 2 httpd
> 15204 nobody    20   0  201m  10m 7380 S  1.5  0.1   0:00.66 2 httpd
> 15051 nobody    20   0  203m  12m 7716 S  1.0  0.2   0:01.43 2 httpd
> 15059 nobody    20   0  204m  13m 9232 S  1.0  0.2   0:01.22 2 httpd
> 15081 nobody    20   0  203m  12m 7724 S  1.0  0.2   0:00.95 2 httpd
> 15319 nobody    20   0  202m  12m 6376 S  1.0  0.2   0:00.26 1 httpd
> 15465 nobody    20   0  199m 8448 5396 S  1.0  0.1   0:00.05 2 httpd
> 15467 nobody    20   0  200m 8872 4568 S  1.0  0.1   0:00.02 2 httpd
> 12215 nobody    20   0  202m  13m 9756 S  0.5  0.2   0:05.54 2 httpd
> 13052 nobody    20   0  205m  14m 9.8m S  0.5  0.2   0:04.36 2 httpd
> 13433 nobody    20   0  203m  14m 9564 S  0.5  0.2   0:05.25 1 httpd 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

