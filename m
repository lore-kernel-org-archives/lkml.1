Return-Path: <linux-kernel-owner+w=401wt.eu-S1751657AbXJUHwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657AbXJUHwS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 03:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbXJUHwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 03:52:09 -0400
Received: from havoc.gtf.org ([69.61.125.42]:43208 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbXJUHwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 03:52:08 -0400
To: LKML <linux-kernel@vger.kernel.org>
From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 0/17] various irq handler cleanups
Message-Id: <lkjvxcz09835mnsdfv0983q4m1234m@havoc.gtf.org>
Date: Sun, 21 Oct 2007 03:52:07 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This series continues the work of running through irq handlers that use
their 'irq' argument -- almost always for trivial (or even wrong)
reasons.

In many cases, this work eliminates some pointless code in the fastpath,
and/or otherwise makes interrupt handling [ever so] slightly more
efficient and clean.

As usual, this work is being committed to the 'irq-cleanups' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git

which encompasses the following changes (includes some previously
posted, and not re-posted in this series):

older cleanups:
      [PARPORT] Consolidate code copies into a single generic irq handler
      [PARPORT] Kill useful 'irq' arg from parport_{generic_irq,ieee1284_interru
      [PARPORT] Remove unused 'irq' argument from parport irq functions
      [BLUETOOTH] Eliminate checks for impossible conditions in irq handler
      Eliminate pointless casts from void* in a few driver irq handlers.
      [SPARC, XEN, NET/CXGB3] use irq_handler_t where appropriate
      [NETDRVR] lib82596, netxen: delete pointless tests from irq handler
      [SCSI] aha152x: delete pointless test in irq handler
      [ATM, CHAR, TOUCHSCREEN] remove needless use of irq handler first arg

new cleanups:
      [IRQ ARG CLEANUP] more driver cleanups
      drivers/char/ip2: split out irq core logic into separate function
      drivers/char/ip2: separate polling and irq-driven work entry points
      char/pcmcia/synclink_cs: trim trailing whitespace
      drivers/char/pcmcia/synclink_cs.c: irq handler cleanups
      drivers/char/riscom8: irq handler cleanups
      drivers/char/{rio,specialix,sx}: irq handler cleanups
      arch/x86/kernel/vm86_32.c: irq handler cleanup
      drivers/char/{synclink,tpm}: irq handler cleanups
      drivers/input/serio/i8042.c: irq handler clean
      isdn/act2000: fix major bug. clean irq handler.
      isdn/sc: irq handler clean
      [netdrvr] driver irq handler cleanups
      pcmcia/i82365: irq handler cleanups
      serial, rtc/ds1374: irq handler cleanups
      [SCSI] driver irq handler cleanups
      RTC interrupt handling cleanups

