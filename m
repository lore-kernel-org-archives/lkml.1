Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab0CITc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 14:32:29 -0500
Received: from ipo3.cc.utah.edu ([155.97.131.71]:16617 "EHLO ipo3.cc.utah.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab0CITc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 14:32:27 -0500
X-SBRS: None
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmUWAMMwlkubYbWV/2dsb2JhbACTP4d3c7AYAQmFMYhZAoJnghAEgxcc
X-IronPort-AV: E=Sophos;i="4.49,610,1262588400"; 
   d="scan'208";a="110408395"
Message-ID: <4B96A24A.6060405@utah.edu>
Date: Tue, 09 Mar 2010 12:32:26 -0700
From: Tom Ammon <tom.ammon@utah.edu>
Organization: University of Utah CHPC
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091204 Lightning/1.0b1 Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: how to tweak ARP timer on kernel 2.6.9
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Mar 2010 19:32:27.0019 (UTC) FILETIME=[40327DB0:01CABFBF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been trying to figure out how to adjust the ARP timeout on kernel 
2.6.9 and I found the following in /proc/sys/net/ipv4/neigh/ib0 (its an 
IB interface I am interested in changing) with the following values. 
This is on kernel 2.6.9-89ELsmp (RHEL4) :

[root@up255 ib0]# cat anycast_delay
99
[root@up255 ib0]# cat app_solicit
0
[root@up255 ib0]# cat base_reachable_time
30
[root@up255 ib0]# cat delay_first_probe_time
5
[root@up255 ib0]# cat gc_stale_time
60
[root@up255 ib0]# cat locktime
99
[root@up255 ib0]# cat mcast_solicit
3
[root@up255 ib0]# cat proxy_delay
79
[root@up255 ib0]# cat proxy_qlen
64
[root@up255 ib0]# cat retrans_time
99
[root@up255 ib0]# cat ucast_solicit
3
[root@up255 ib0]# cat unres_qlen
3

When I test this, along with per-flow ECMP (using the iproute2 utils), I 
see that the ARP cache is timing out about every 10 minutes (I observe 
this by load balancing an iperf flow between two different gateway 
machines and then graphing the interface traffic)

On a newer kernel, 2.6.18-164.11.1.el5 (RHEL5), I see mostly the same 
parms available, but a few new ones have been added. However, all of the 
parms that are the same name between the two kernels are the same values:

[root@gateway2 ib0]# cat anycast_delay
99
[root@gateway2 ib0]# cat app_solicit
0
[root@gateway2 ib0]# cat base_reachable_time
30
[root@gateway2 ib0]# cat base_reachable_time_ms
30000
[root@gateway2 ib0]# cat delay_first_probe_time
5
[root@gateway2 ib0]# cat gc_stale_time
60
[root@gateway2 ib0]# cat locktime
99
[root@gateway2 ib0]# cat mcast_solicit
3
[root@gateway2 ib0]# cat proxy_delay
79
[root@gateway2 ib0]# cat proxy_qlen
64
[root@gateway2 ib0]# cat retrans_time
99
[root@gateway2 ib0]# cat retrans_time_ms
1000
[root@gateway2 ib0]# cat ucast_solicit
3
[root@gateway2 ib0]# cat unres_qlen
3

Yet when I observe the same traffic flow with this machine, the ARP 
cache times out about once per minute.

Is there another set of parameters somewhere that govern how often the 
kernel times out the ARP cache? If so, where might I find that? Is there 
any kernel documentation that talks about changing ARP timers on the 
linux kernel?

Tom Ammon

-- 
--------------------------------------------------------------------
Tom Ammon
Network Engineer
Office: 801.587.0976
Mobile: 801.674.9273

Center for High Performance Computing
University of Utah
http://www.chpc.utah.edu

