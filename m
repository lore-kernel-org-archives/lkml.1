Return-Path: <linux-kernel-owner+w=401wt.eu-S1757690AbYILW75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690AbYILW75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 18:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755142AbYILW7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 18:59:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43805
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754993AbYILW7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 18:59:47 -0400
Date: Fri, 12 Sep 2008 15:59:41 -0700 (PDT)
Message-Id: <20080912.155941.143908227.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) On sparc32, of_bus_sbus_get_flags() has wrong types for the
   function pointer it gets assigned to.

2) Meelis Roos reported e3500 bootup failures:
   a) PCI controller interrupt register code was using a fixed
      table (which was missing some entries), when in fact the
      values can be computed using a simple formula from the
      programmers manual.
   b) IRQs for PCI controller error interrupts can be shared,
      so we have to pass IRQF_SHARED to request_irq()

   There are still some problems with this system, some devices
   aren't showing up, but for the most part the machine is working
   now.

3) user_regset->n values were wrong on sparc, resuling in improperly
   sized core file sections.

Please pull, thanks a lot.

The following changes since commit 2eb2f77900d62796934bcd43c4089e444cf1179e:
  David S. Miller (1):
        sparc64: Disable timer interrupts in fixup_irqs().

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (4):
      sparc64: Fix interrupt register calculations on Psycho and Sabre.
      sparc32: Fix function signature of of_bus_sbus_get_flags().
      sparc64: Fix PCI error interrupt registry on PSYCHO.
      sparc: Fix user_regset 'n' field values.

 arch/sparc/kernel/of_device.c    |    2 +-
 arch/sparc/kernel/ptrace.c       |    4 +-
 arch/sparc64/kernel/pci_psycho.c |    6 +-
 arch/sparc64/kernel/prom.c       |  104 ++-----------------------------------
 arch/sparc64/kernel/ptrace.c     |    8 ++--
 5 files changed, 16 insertions(+), 108 deletions(-)
