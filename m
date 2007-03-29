Return-Path: <linux-kernel-owner+w=401wt.eu-S1945899AbXC2WYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945899AbXC2WYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 18:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945895AbXC2WYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 18:24:34 -0400
Received: from fallback.us4.outblaze.com ([205.158.62.120]:34038 "EHLO
	fallback.us4.outblaze.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945899AbXC2WYc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 18:24:32 -0400
X-OB-Received: from unknown (205.158.62.232)
  by wfilter.us4.outblaze.com; 29 Mar 2007 22:22:21 -0000
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
From: "Elliott Johnson" <ejohnson@linuxmail.org>
To: linux-kernel@vger.kernel.org
Date: Fri, 30 Mar 2007 06:22:21 +0800
Subject: strange high system cpu usage.
X-Originating-Ip: 209.209.36.196
X-Originating-Server: ws5-11.us4.outblaze.com
Message-Id: <20070329222221.9C53BCA0A4@ws5-11.us4.outblaze.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've been upgrading a few machines here at work and noticed some problems with high system cpu usage on one machine.  In trying to debug the problem I've come across a few confusing stats that I was hoping could be cleared up by someone on this list.

Firstly some info about the system.  It's a dell 2850 running a 32bit gentoo install with glibc 2.5 and kernel 2.6.19.  A single multi-threaded process is generating the system cpu usage.  One of our developers wrote the code and it does some intense disk reads and writes, which should create primarily iowait cpu usage.  On a debian system with the same hardware using glibc-2.4 and kernel 2.6.8 the process generates virtually 0 load compared the the upgraded server's load of 2-4.

Here is some disk usage info:

 dc2 linux # sar -d -p
 17:40:01          DEV       tps  rd_sec/s  wr_sec/s  avgrq-sz  avgqu-sz     await     svctm     %util
 17:45:01          sda      0.61     10.50      5.11     25.47      0.00      1.07      0.91      0.06
 17:45:01          sdb     26.43     41.81    438.41     18.17      0.19      7.10      2.42      6.41
 17:45:01        nodev     26.63     41.81    438.41     18.03      0.19      7.07      2.41      6.41
 17:50:01          sda      0.10      0.35      0.97     13.66      0.00      0.28      0.28      0.00
 17:50:01          sdb     25.45     56.05    523.54     22.77      0.06      2.38      1.88      4.80
 17:50:01        nodev     25.67     56.05    523.54     22.58      0.06      2.38      1.87      4.79

Here is some cpu info:

 dc2 linux # sar -p
 17:40:01        CPU     %user     %nice   %system   %iowait    %steal     %idle
 17:45:01        all      0.05      0.00     20.80      0.27      0.00     78.89
 17:50:01        all      0.03      0.00     26.46      0.24      0.00     73.26

Here are some memory stats:

 dc2 linux # vmstat 3
 procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
  2  0      0 1166088    320 720204    0    0    14    63  131  124  0 23 76  0
  0  0      0 1165832    320 720808    0    0    32   410  400  253  0 30 70  0
  1  0      0 1165028    320 721208    0    0    16   260  469  297  0 22 78  0
  1  0      0 1164228    320 722156    0    0   141    59  474  340  0 27 71  2

dc2 linux # vmstat -s
      2075276  total memory
       993380  used memory
       162412  active memory
       697456  inactive memory
      1081896  free memory
          320  buffer memory
       792036  swap cache
      4152792  total swap
            0  used swap
      4152792  free swap
         1308 non-nice user cpu ticks
            0 nice user cpu ticks
       286057 system cpu ticks
       951507 idle cpu ticks
         3378 IO-wait cpu ticks
          188 IRQ cpu ticks
          362 softirq cpu ticks
            0 stolen cpu ticks
       157581 pages paged in
       780844 pages paged out
            0 pages swapped in
            0 pages swapped out
      1617473 interrupts
      1506805 CPU context switches
   1175215011 boot time
         7709 forks


We rebooted it a few moments ago, but before that vmstat showed that the buffered memory was 0kb.  This is very different from the other machine which has around 500Mb.  A low buffer mem count seems common in our machines with kernel 2.6.17-2.6.19.  Looking at vmstat's man page its difficult to understand exactly what buffered mem is and how to go about altering things to get this value higher to test with.  It seems to be a computed value and not something settable via /proc.  Does any one know more about buffered memory and how to adjust it?

-Elliott Johnson

=
Search for products and services at: 
http://search.mail.com

-- 
Powered by Outblaze
