Return-Path: <linux-kernel-owner+w=401wt.eu-S1761509AbXESMRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761509AbXESMRd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 08:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758069AbXESMR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 08:17:26 -0400
Received: from mk-ironport-2.mail.uk.tiscali.com ([212.74.114.25]:36060 "EHLO
	mk-ironport-2.mail.uk.tiscali.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758012AbXESMRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 08:17:25 -0400
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 May 2007 08:17:25 EDT
X-SBRS: 4.7
X-RemoteIP: 212.74.114.12
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAALaETkbUSnIMk2dsb2JhbACQEgEBAgcGCAcFHw
Subject: 2.6.22-rc2 prepatch breaks compile on Dreamcast
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: linuxsh-dev@lists.sourceforge.net
Cc: Andrew Morton <akpm@osdl.org>, Paul Mundt <lethal@linux-sh.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 19 May 2007 13:07:00 +0100
Message-Id: <1179576420.5998.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Antivirus-Scanner: Scanned with ClamAV
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The patch includes:

-#if OFFCHIP_NR_IRQS > 0
-# define OFFCHIP_IRQ_BASE (ONCHIP_NR_IRQS + PINT_NR_IRQS)
-#endif


but the OFFCHIP_IRQ_BASE symbol is still referenced in the Dreamcast
code, so a compile generates this:

arch/sh/boards/dreamcast/irq.c: In function `disable_systemasic_irq':
arch/sh/boards/dreamcast/irq.c:59: error: `OFFCHIP_IRQ_BASE' undeclared
(first use in this function)
arch/sh/boards/dreamcast/irq.c:59: error: (Each undeclared identifier is
reported only once
arch/sh/boards/dreamcast/irq.c:59: error: for each function it appears
in.)
arch/sh/boards/dreamcast/irq.c: In function `enable_systemasic_irq':
arch/sh/boards/dreamcast/irq.c:70: error: `OFFCHIP_IRQ_BASE' undeclared
(first use in this function)
arch/sh/boards/dreamcast/irq.c: In function `ack_systemasic_irq':
arch/sh/boards/dreamcast/irq.c:81: error: `OFFCHIP_IRQ_BASE' undeclared
(first use in this function)
arch/sh/boards/dreamcast/irq.c: In function `systemasic_irq_demux':
arch/sh/boards/dreamcast/irq.c:146: error: `OFFCHIP_IRQ_BASE' undeclared
(first use in this function)



