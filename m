Return-Path: <linux-kernel-owner+w=401wt.eu-S1759900AbYDBTel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759900AbYDBTel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 15:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757894AbYDBTef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 15:34:35 -0400
Received: from smtp5.freeserve.com ([193.252.22.152]:61324 "EHLO
	smtp5.freeserve.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757903AbYDBTee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 15:34:34 -0400
X-Greylist: delayed 1155 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Apr 2008 15:34:34 EDT
X-ME-UUID: 20080402191513840.CD4391C00086@mwinf3422.me.freeserve.com
Cc: linux-kernel@vger.kernel.org
Message-Id: <7CA56108-1CC9-4217-80AF-C7F378D23FA9@shu.ac.uk>
From: Tim Schmielau <T.Schmielau@shu.ac.uk>
To: Laurent GUERBY <laurent@guerby.net>
In-Reply-To: <1205013615.15075.409.camel@localhost>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: BUG: soft lockup detected on Phenom with Debian 2.6.24-4
Date: Wed, 2 Apr 2008 20:15:00 +0100
References: <1205013615.15075.409.camel@localhost>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[apologies if you receive this email twice; apparently the exchange  
server
this message was sent through previously triggered one of lkml's taboo
expressions]

On Sat, 08 Mar 2008 23:00:15 +0100, Laurent GUERBY wrote:

 > I have a system with an "AMD64 Phenom 9500" quad core cpu, 4GB RAM,
 > "ASUS M3A32 MVP Deluxe wifi" motherboard with latest vendor BIOS  
(0801).
 >
 > I tried stock debian etch kernel (Debian 2.6.18.dfsg.1-18etch1),  
machine
 > froze with no message, debian etch backport kernel same, and then
 > Debian 2.6.24-4 from unstable and I got some messages: machine
 > is not frozen but some userland processes are (ps says "Dl" state
 > with child in "Zs" state) and "events/3" is taking 100% cpu
 > according to top:
 >
 >    18 root      15  -5     0    0    0 R  100  0.0  74:59.46 events/3
 >
 > Got to the same state with ubuntu hardy 2.6.24-8-server kernel. All
 > kernels are untainted, no X running anyway.
 >
 > It takes a few hours of doing some stuff, in my case bootstraping or
 > testing GCC at -j 4, and then the problem happens.
 >
 > I did 32 hours of memtest without issue on this system, temperatures
 > are very low and the case has plenty of airflow, making memory
 > issue less likely.

I have a very similar, if not the same issue:

I just bought a HP Pavillion 6332 with a Phenom 9500 quad core cpu and
3GB RAM on some ASUS-like looking mainboard with NVidia MCP61 chipset
(actually my first PC not assembled from components myself).
I installed OpenSUSE 10.3 64bit and tried various kernels (2.6.24.4,
2.6.23.17 + the erratum298-workaround from AMD, OpenSUSE's default
2.6.22.5-31 and 2.6.22.17-0.1), but the machine will hang within less
than an hour of intense OpenMP load over all four cores (using a
homemade scientific application).

The symptoms of the hang are similar to what Laurent saw: In xosview,
the load display one cpu would get stuck (not necessarily at 100%), and
usually (but not always) ps would hang in the middle of its output. I
could still login (no X running here either) and use the remaining  
cores,
but the OpenMP application would hang in an unkillable state (don't
know which as ps gets stuck). Unlike Laurent, I however don't see
anything relevant in the syslog.

Occasionally I also had wrong output from the program (i.e., running it
twice gives different results, one of them bogus), although that was on
32bit OpenSUSE 10.3, as far as I remember. I know due to the nature of
OpenMP this could as well be a bug in my program, but it has not yet
happened on any other machine.

The system is well vented and very cool, but as of yet I only had time
to run memtest for 6 hours (no errors found).

If anybody has an idea how to debug this, please ask for more
information, otherwise I'll just return this machine for refund.

Thanks,
Tim

