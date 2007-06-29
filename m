Return-Path: <linux-kernel-owner+w=401wt.eu-S932078AbXF2HOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbXF2HOP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 03:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbXF2HN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 03:13:59 -0400
Received: from mail.gmx.net ([213.165.64.20]:58009 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751255AbXF2HN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 03:13:57 -0400
X-Authenticated: #1474915
X-Provags-ID: V01U2FsdGVkX1/dnvxO7uTd+rVlbJYSXlRjcWUHXtn4lKy0oJcjYq
	3vYTFOIljQllRK
Message-ID: <4684B132.2070405@gmx.de>
Date: Fri, 29 Jun 2007 09:13:54 +0200
From: Thomas Sattler <tsattler@gmx.de>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.22-rc6 spurious hangs
References: <4683BF16.40905@gmx.de> <20070628144741.GA437@tv-sign.ru> <4683CC89.80406@gmx.de> <20070628150826.GA487@tv-sign.ru> <4683F145.2060705@gmx.de> <4683F48F.9010603@gmx.de> <20070628181044.GA613@tv-sign.ru>
In-Reply-To: <20070628181044.GA613@tv-sign.ru>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> Jun 28 19:23:03 pearl cinergyt2_query_rc+0x0/0x2e9 [cinergyT2]
> 
> cinergyt2_query_rc() hangs. I'll try to look tomorrov, but I know nothing
> about drivers/media/dvb/.

Does this mean the problem is in the cinergyt2 driver? I'm having similar
problems with another box but with different hardware. While my laptop is
used as a test system the other one is used as a 'productive' TV-recorder.
I hoped we could trace the bug on the test system and fix the productive
one at the same time. :-/

The other box ("silver") is a desktop, which has two Hauppauge Nova-T DVB-T
PCI cards and one (analog) Hauppauge WinTV PVR-350. Silver only hangs if
the (digital) recording process has to much priority: (silver is running
2.6.21.5-cfs-v17 +squashfs +ivtv)

As I wanted to give as much priority to the recording process as possible
I firstly run dvbd as SCHED_RR. This hung the box quite often, sometimes
after an uptime of several minutes, sometimes after two weeks.

I switched to -ck and run dvbd as SCHED_ISO which worked without *any*
problem for about 18 months. As -ck is discontinued I switched to CFS and
the box hung again (twice until I understood why) when dvbd was running as
nice -15.

ATM dvbd runs with nice -12 but yesterday, during a rsync-transfer of
several >4G files, a recording was broken. 29 seconds of the recorded
stream are lost because the system load was at 5 for about three hours.

Perhaps the 29 missing seconds are caused not by to less CPU time but by
the havy IO of rsync. But on the other hand dvbd is also running at IO
realtime prio 4 (ionice) while rsync run as IO normal.

Any hints?
Thomas

-- 
keep mailinglists in english, feel free to send PM in german
