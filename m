Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbYESPhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbYESPhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755629AbYESPhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:37:20 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43563 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbYESPhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:37:17 -0400
Subject: Re: Hello and a question about high cpu usage on jfsCommit (kernel
	2.6.25.1)
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: David Fix <davidf@mrxfx.com>
Cc: linux-kernel@vger.kernel.org,
       JFS Discussion <jfs-discussion@lists.sourceforge.net>
In-Reply-To: <482C9090.5040901@mrxfx.com>
References: <482C9090.5040901@mrxfx.com>
Content-Type: text/plain
Date: Mon, 19 May 2008 10:37:13 -0500
Message-Id: <1211211433.6283.14.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm copying this to jfs-discussion to see if anyone has seen anything
like this.

On Thu, 2008-05-15 at 15:35 -0400, David Fix wrote:
> Hey guys,
> 
> I'm new to the list, but I've been using Linux and fooling around with 
> the kernel for ages.  :)
> 
> I've been experiencing high CPU usage for jfsCommit on kernel 2.6.25.1 
> (haven't had a chance to go to 2.6.25.4, but I didn't see any 
> JFS-specific changes between the versions yet).

In fact, there haven't been a whole lot of non-cosmetic changes to jfs
at all recently.  Nothing I see that suspicious.

What was the previous kernel you were running before moving to 2.6.25.1?

> Here's my hardware 
> config, as well:
> 
> 
> CPUs: 2x Intel Xeon E5420 2.5GHz Quad-core
> RAM: 8GB
> RAID Controller: 3Ware 9650SE-24M8

For anyone seeing this for the first time on jfs-discussion, Dave
followed up stating that this was an x86_64 build.

> I can't find a mention of what motherboard I have in here, so I'll give 
> a bit of lspci:
> 
> 00:00.0 Host bridge: Intel Corporation 5000P Chipset Memory Controller 
> Hub (rev b1)
> 00:1d.0 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
> UHCI USB Controller #1 (rev 09)
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9)
> 01:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express 
> Upstream Port (rev 01)
> 03:00.0 PCI bridge: Integrated Device Technology, Inc. Unknown device 
> 8018 (rev 04) (prog-if 00 [Normal decode])
> 05:00.0 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet 
> Controller (rev 06)
> 07:00.0 Ethernet controller: Intel Corporation 80003ES2LAN Gigabit 
> Ethernet Controller (Copper) (rev 01)
> 0c:00.0 RAID bus controller: 3ware Inc 9650SE SATA-II RAID (rev 01)
> 0f:0c.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)
> 
> There's the salient points there.  The NIC is a quad, which is trunked 
> to the switch using LAPC.
> 
> I've got a RAID-6 on the 3Ware controller of 20 TB, and when I'm running 
> "top", I see this:
> 
> ---
> top - 15:33:27 up  5:40,  3 users,  load average: 4.33, 3.59, 3.98
> Tasks: 315 total,   2 running, 313 sleeping,   0 stopped,   0 zombie
> Cpu(s):  0.2%us, 13.2%sy,  0.0%ni, 61.3%id, 24.9%wa,  0.1%hi,  0.2%si,  
> 0.0%st
> Mem:   8194264k total,  8144500k used,    49764k free,     3884k buffers
> Swap: 16779884k total,      148k used, 16779736k free,  7667400k cached
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  2669 root      15  -5     0    0    0 R   99  0.0  19:45.71 jfsCommit

This is highly unusual.  Is this thread continually eating cpu at this
rate, or does it happen in spurts?

> And people are complaining (and I'm seeing) very slow writes to the drives.
> 
> Just wondering if anyone has any ideas.  :)  If you need any 
> information, I'll provide whatever you need.

Has this happened more than once (have you rebooted and still seen the
problem)?  I'm not sure if some rare bug has caused some kind of linked
list corruption that puts the thread into an infinite loop, or if this
is a real regression.

> Thanks in advance!
> 
>     Dave

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

