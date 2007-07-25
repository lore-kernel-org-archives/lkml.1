Return-Path: <linux-kernel-owner+w=401wt.eu-S1763910AbXGYMiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763910AbXGYMiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761812AbXGYMhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:37:46 -0400
Received: from rex.snapgear.com ([203.143.235.140]:47277 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761541AbXGYMho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:37:44 -0400
Message-ID: <46A74415.7000408@snapgear.com>
Date: Wed, 25 Jul 2007 22:37:41 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [M68KNOMMU]: create hw_irq.h
References: <200707251207.l6PC7KiH032176@goober> <20070725121724.GA4923@infradead.org>
In-Reply-To: <20070725121724.GA4923@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Wed, Jul 25, 2007 at 10:07:20PM +1000, Greg Ungerer wrote:
>> Need an include/asm-m68knommu/hw_irq.h for kernel/hrtimer.c
> 
> hrtimer.c should be fixed not to include it instead.

Indirectly it is coming from include/linux/irq.h
(which means that compilation of a few kernel/irq/*.c files
fail on m68knommu without hw_irq.h existing too)

Can we just take out that include from there?

--- linux-2.6.23-rc1/include/linux/irq.h        2007-07-25 
16:39:30.000000000 +1000
+++ linux/include/linux/irq.h   2007-07-25 22:36:28.000000000 +1000
@@ -186,11 +186,6 @@
  #define no_irq_type            no_irq_chip
  typedef struct irq_desc                irq_desc_t;

-/*
- * Pick up the arch-dependent methods:
- */
-#include <asm/hw_irq.h>
-
  extern int setup_irq(unsigned int irq, struct irqaction *new);

  #ifdef CONFIG_GENERIC_HARDIRQS


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
SnapGear -- a Secure Computing Company      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
