Return-Path: <linux-kernel-owner+w=401wt.eu-S1757394AbYJIDNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbYJIDNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 23:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbYJIDNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 23:13:10 -0400
Received: from kroah.org ([198.145.64.141]:55083 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751725AbYJIDNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 23:13:09 -0400
Date: Wed, 8 Oct 2008 20:11:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.25.18
Message-ID: <20081009031118.GA1602@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.25.18
kernel.

It contains lots of bugfixes, all over the map.  Any users of the 2.6.25
kernel series should upgrade to this version.  For details on the fixes,
see the changelog entries and the diffstat below.

I'll also be replying to this message with a copy of the patch between
2.6.25.17 and 2.6.25.18

The updated 2.6.25.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.25.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.25.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                         |    2 
 arch/x86/kernel/hpet.c           |   19 ++++--
 arch/x86/kernel/io_delay.c       |    8 ++
 arch/x86/kernel/vmi_32.c         |    2 
 drivers/acpi/ec.c                |    2 
 drivers/acpi/processor_perflib.c |    2 
 drivers/i2c/i2c-dev.c            |    4 +
 drivers/mmc/card/block.c         |    4 +
 drivers/net/niu.c                |   56 ++++++++++++++++++
 drivers/spi/pxa2xx_spi.c         |  116 ++++++++++++++++++++++++++++++---------
 drivers/usb/core/hcd.c           |    3 -
 include/asm-generic/rtc.h        |   12 +---
 include/linux/clockchips.h       |    2 
 include/net/netlink.h            |    2 
 kernel/time/clockevents.c        |    3 -
 kernel/time/ntp.c                |    2 
 kernel/time/tick-broadcast.c     |   78 +++++++++++++++++++-------
 kernel/time/tick-common.c        |    1 
 kernel/time/tick-internal.h      |    2 
 kernel/time/tick-oneshot.c       |   44 ++++++++++++--
 net/ipv4/udp.c                   |   57 +++++++++++--------
 net/ipv6/ip6_output.c            |   64 ++++++++++-----------
 net/ipv6/udp.c                   |    6 +-
 net/sctp/associola.c             |    9 +--
 net/sctp/sm_make_chunk.c         |   15 +++--
 25 files changed, 371 insertions(+), 144 deletions(-)


Andrew Morton (1):
      drivers/mmc/card/block.c: fix refcount leak in mmc_block_open()

Chuck Ebbert (1):
      x86: add io delay quirk for Presario F700

Geoff Levand (1):
      USB: fix hcd interrupt disabling

Greg Kroah-Hartman (1):
      Linux 2.6.25.18

Herbert Xu (1):
      udp: Fix rcv socket locking

Ingo Molnar (1):
      rtc: fix deadlock

Maciej W. Rozycki (1):
      ntp: fix calculation of the next jiffie to trigger RTC sync

Mike Rapoport (1):
      pxa2xx_spi: fix build breakage

Milan Broz (1):
      ACPI: Fix thermal shutdowns

Ned Forrester (2):
      pxa2xx_spi: dma bugfixes
      pxa2xx_spi: chipselect bugfixes

Neil Horman (1):
      ipv6: Fix OOPS in ip6_dst_lookup_tail().

Santwona Behera (1):
      niu: panic on reset

Sven Wegener (1):
      i2c-dev: Return correct error code on class_create() failure

Thomas Gleixner (9):
      clockevents: prevent endless loop in periodic broadcast handler
      clockevents: enforce reprogram in oneshot setup
      clockevents: prevent multiple init/shutdown
      clockevents: prevent endless loop lockup
      HPET: make minimum reprogramming delta useful
      clockevents: broadcast fixup possible waiters
      x86: HPET fix moronic 32/64bit thinko
      x86: HPET: read back compare register before reading counter
      clockevents: remove WARN_ON which was used to gather information

Vegard Nossum (1):
      netlink: fix overrun in attribute iteration

Venkatesh Pallipadi (1):
      clockevents: prevent clockevent event_handler ending up handler_noop

Vlad Yasevich (2):
      sctp: do not enable peer features if we can't do them.
      sctp: Fix oops when INIT-ACK indicates that peer doesn't support AUTH

Zachary Amsden (1):
      x86: Fix broken LDT access in VMI

Zhao Yakui (1):
      ACPI: Avoid bogus EC timeout when EC is in Polling mode

