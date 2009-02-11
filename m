Return-Path: <linux-kernel-owner+w=401wt.eu-S1758138AbZBKRVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138AbZBKRVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 12:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756885AbZBKRV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 12:21:29 -0500
Received: from web.proformatique.com ([91.194.179.68]:39742 "EHLO
	proformatique.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756908AbZBKRV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 12:21:29 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Feb 2009 12:21:28 EST
Date: Wed, 11 Feb 2009 18:14:31 +0100
From: Guillaume Knispel <gknispel@proformatique.com>
To: <linux-kernel@vger.kernel.org>
Subject: Interrupt synchronisation questions for SMP experts
Message-ID: <20090211181431.47f42dde@xilun.lan.proformatique.com>
Organization: Proformatique
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

1. Imagine an interrupt storm from an evil device on an evil SMP
machine, is there any guarantee that if the ISR call
disable_irq_nosync() on its own irq it won't be called again just after
it returns?  I feel this could be a reasonable expectation while i fail
to see anything that could provide it in the for (;;) loop of
__do_IRQ().

2. Does using synchronizing functions like disable_irq(),
tasklet_kill(), or del_timer_sync() provide sequentiality between the
effects of the end of the interrupt servicing code and the effects of
the code immediately after the call to the synchronizing function?

3. Consider this:

(a initially set to 0)
  CPU 1.          CPU 2.

  z = 3;          while (!a) barrier();
  smp_wmb();      smp_mb();
  a = 1;          z = 42;

Does the semantic of smp_mb() and smp_wmb() guarantee that the final
value of z will be 42?  (This has something to do with 2.)

Cheers,
Guillaume KNISPEL
