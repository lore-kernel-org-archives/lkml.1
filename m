Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbXKRRPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbXKRRPm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 12:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbXKRRPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 12:15:20 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:63105 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbXKRRPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 12:15:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=m59k85L6pXk/nxeiM2GND/F9pxzVc5aPDY2G8xU2aUjQGTYDi3Drpf/m+3j1570VWyMMXmG03M0YaJs+PvsVeNNM4u8MEvHQrubu8nGW+XvsdORbZxvmsGkV134kGTs4H2dAMOUCqb0ix9ZE3ZLWw5HyPgTEKRR49cv7f5A0mpw=
Message-ID: <dc5675e90711180915t45fa56c3le65b624161d4e09b@mail.gmail.com>
Date: Sun, 18 Nov 2007 12:15:17 -0500
From: "Richard Harman" <richard.harman@gmail.com>
To: linux-kernel@vger.kernel.org, richard.harman@gmail.com
Subject: HP Pavilion DV6408nr timer/irq related? hard lockup
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(I'm not on the list, please CC me in your replies)

I have a HP DV6409nr Pavilion notebook that came preloaded with
Windows Vista that Linux doesn't seem to want to boot properly on.

Currently, 'noapic noirqdebug' sort-of works for x86_64 kernels, but
Vista seems to be able to use the APIC just fine.  I've disassembled
the BIOS to pull out the bios pirq and routing table and from what I
can tell, it's pretty flexible -- Linux and Vista both set up the same
IRQs when in APIC mode, save for the HPET.  Vista sticks the HPET on
IRQ 0 and 8, Linux sticks it on 2, 8, and 31.  The two USB controllers
get assigned IRQ 22 in both Vista and Linux, but under Linux a few
seconds after accessing a USB device causes the system to lock up
solid without an oops.  Most of all I'm trying to get this laptop
running in APIC mode so I can run Xen.

This system has no serial port, and USB seems to be problematic; can
anyone suggest how to figure out what is causing the lock up?  When
the system freezes, it locks up so solid that sysrq doesn't work.
