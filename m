Return-Path: <linux-kernel-owner+w=401wt.eu-S1756433AbZFNKHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbZFNKHp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 06:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbZFNKHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 06:07:38 -0400
Received: from mail.gmx.net ([213.165.64.20]:43752 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751834AbZFNKHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 06:07:37 -0400
X-Authenticated: #3576790
X-Provags-ID: V01U2FsdGVkX1/XlesVBunX9ZN/OpwxRRB54F3CKfgCEn0f3OA46U
	KRrHTI+6a5bc5c
Date: Sun, 14 Jun 2009 12:09:50 +0200
From: "Benjamin S." <sbenni@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, js@sig21.net
Subject: 2.6.30 enabling cpu1 on resume fails after suspend to memory
Message-ID: <20090614120950.116536fa@pluto-lenny.milky.way>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I think I have the same problem Johannes has posted there:

http://marc.info/?l=linux-kernel&m=124475174614672&w=2

My motherboard is a Gigabyte GA-MA78G-DS3H rev. 1.0 (chipset SB700 - the 
same as Johannes' chipset) and my CPU is a AMD 4850e (also the same
as Johannes' CPU). Thus I see the same error on resume after suspend
to memory:

Initializing CPU#1
Stuck ??
Error taking CPU#1 up: -5


After bisecting all revisions between 2.6.29 and 2.6.30 the first bad 
revision seems to be:

commit 2ed8d2b3a81bdbb0418301628ccdb008ac9f40b7
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Mon Mar 16 22:34:06 2009 +0100

    PM: Rework handling of interrupts during suspend-resume

    Use the functions introduced in by the previous patch,
    suspend_device_irqs(), resume_device_irqs() and check_wakeup_irqs(),
    to rework the handling of interrupts during suspend (hibernation) and
    resume.  Namely, interrupts will only be disabled on the CPU right
    before suspending sysdevs, while device drivers will be prevented
    from receiving interrupts, with the help of the new helper function,
    before their "late" suspend callbacks run (and analogously during
    resume).

    In addition, since the device interrups are now disabled before the
    CPU has turned all interrupts off and the CPU will ACK the interrupts
    setting the IRQ_PENDING bit for them, check in sysdev_suspend() if
    any wake-up interrupts are pending and abort suspend if that's the
    case.

    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Ingo Molnar <mingo@elte.hu>



Best Regards, 

Benjamin
