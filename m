Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbXJIF1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbXJIF1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 01:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbXJIF1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 01:27:25 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:12761 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbXJIF1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 01:27:25 -0400
Message-ID: <470B1119.8040207@sw.ru>
Date: Tue, 09 Oct 2007 09:26:49 +0400
From: Vasily Averin <vvs@sw.ru>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>
CC: devel@openvz.org
Subject: irq0 stops working
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On one of our servers timer interrupts (i.e irq0) are stops working. As result
any kernel timers do not triggers and tasks waiting some signals from timers
hangs forever.

Most noticeable effect of this situation is that any write operations to disk
are stalled, and nobody can log in on the node.

At the same time node all existing shells works away. I'm able to read
interrupts statistic from /proc/interrupts file and it shows that all other
interrupts are changed when these devices are accessed: disk on sata controller,
network, cdrom on ide controller, keyboard, serial console, LOC interrupts.

Also I've found that disable of irqbalance service on the node helps to
workaround this issue, however of course it fixes nothing.

All details about hardware/logs could be found in
http://bugzilla.kernel.org/show_bug.cgi?id=8650

I'm able to reproduce this situation, however now I have no ideas how to
continue the investigation of this problem.

Could please anybody advise me any new ways for investigation of this issue?

Thank you,
	Vasily Averin

OpenVZ Linux Kernel Team
