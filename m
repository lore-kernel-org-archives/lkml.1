Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab0CLJo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 04:44:56 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:55736 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab0CLJoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 04:44:55 -0500
X-IronPort-AV: E=Sophos;i="4.49,625,1262581200"; 
   d="scan'208";a="87802722"
Subject: [GITPULL+PATCH 0/2] irq: move some interrupt arch_* functions into
 struct irq_chip.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, "x86@kernel.org" <x86@kernel.org>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Fri, 12 Mar 2010 09:44:51 +0000
Message-ID: <1268387091.10129.5973.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small series ensures that struct irq_desc->chip_data is available
for alternative irq_chip implementations.

There is an outstanding issue wrt when/how the chip_data field is
initialised. I am continuing to investigate this but the solution is not
turning out as easy/low-impact as expected.

Since last time I've dropped the renaming portion of the series since it
was basically wrong, the functions I'd implicated as ioapic specific are
not at all.

Ian.

The following changes since commit 1ebbdcc83e75697c0d75eb091df172b7d93c84c1:
  Ingo Molnar (1):
        Merge branch 'perf/urgent'

are available in the git repository at:

  git://xenbits.xensource.com/people/ianc/linux-2.6.git for-x86/irq

Ian Campbell (2):
      irq: move some interrupt arch_* functions into struct irq_chip.
      x86: irq_desc->chip_data is always correct whether or not SPARSE_IRQ is enabled.

 arch/powerpc/kernel/irq.c      |    2 +-
 arch/x86/include/asm/hw_irq.h  |   11 ++++++-
 arch/x86/kernel/apic/io_apic.c |   61 ++++++++++++++++++++++++++++++++++-----
 arch/x86/kernel/uv_irq.c       |    5 +++
 include/linux/interrupt.h      |    2 +-
 include/linux/irq.h            |   12 +++++--
 kernel/irq/handle.c            |    2 +-
 kernel/irq/numa_migrate.c      |   12 ++++++-
 kernel/softirq.c               |    3 +-
 9 files changed, 90 insertions(+), 20 deletions(-)


