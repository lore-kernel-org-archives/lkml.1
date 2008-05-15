Return-Path: <linux-kernel-owner+w=401wt.eu-S1763069AbYEOUGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763069AbYEOUGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbYEOUG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:06:27 -0400
Received: from mail.mrxfx.com ([209.82.53.180]:47915 "EHLO mrxfx.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750830AbYEOUG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:06:26 -0400
X-Greylist: delayed 1837 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 May 2008 16:06:26 EDT
Message-ID: <482C9090.5040901@mrxfx.com>
Date: Thu, 15 May 2008 15:35:44 -0400
From: David Fix <davidf@mrxfx.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Hello and a question about high cpu usage on jfsCommit (kernel 2.6.25.1)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey guys,

I'm new to the list, but I've been using Linux and fooling around with 
the kernel for ages.  :)

I've been experiencing high CPU usage for jfsCommit on kernel 2.6.25.1 
(haven't had a chance to go to 2.6.25.4, but I didn't see any 
JFS-specific changes between the versions yet).  Here's my hardware 
config, as well:


CPUs: 2x Intel Xeon E5420 2.5GHz Quad-core
RAM: 8GB
RAID Controller: 3Ware 9650SE-24M8

I can't find a mention of what motherboard I have in here, so I'll give 
a bit of lspci:

00:00.0 Host bridge: Intel Corporation 5000P Chipset Memory Controller 
Hub (rev b1)
00:1d.0 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
UHCI USB Controller #1 (rev 09)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9)
01:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express 
Upstream Port (rev 01)
03:00.0 PCI bridge: Integrated Device Technology, Inc. Unknown device 
8018 (rev 04) (prog-if 00 [Normal decode])
05:00.0 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet 
Controller (rev 06)
07:00.0 Ethernet controller: Intel Corporation 80003ES2LAN Gigabit 
Ethernet Controller (Copper) (rev 01)
0c:00.0 RAID bus controller: 3ware Inc 9650SE SATA-II RAID (rev 01)
0f:0c.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)

There's the salient points there.  The NIC is a quad, which is trunked 
to the switch using LAPC.

I've got a RAID-6 on the 3Ware controller of 20 TB, and when I'm running 
"top", I see this:

---
top - 15:33:27 up  5:40,  3 users,  load average: 4.33, 3.59, 3.98
Tasks: 315 total,   2 running, 313 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.2%us, 13.2%sy,  0.0%ni, 61.3%id, 24.9%wa,  0.1%hi,  0.2%si,  
0.0%st
Mem:   8194264k total,  8144500k used,    49764k free,     3884k buffers
Swap: 16779884k total,      148k used, 16779736k free,  7667400k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 2669 root      15  -5     0    0    0 R   99  0.0  19:45.71 jfsCommit
---

And people are complaining (and I'm seeing) very slow writes to the drives.

Just wondering if anyone has any ideas.  :)  If you need any 
information, I'll provide whatever you need.

Thanks in advance!

    Dave
