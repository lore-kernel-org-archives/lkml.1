Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbZIRBWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbZIRBWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 21:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbZIRBWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 21:22:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:15655 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbZIRBWw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 21:22:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,406,1249282800"; 
   d="scan'208";a="551605417"
Date: Fri, 18 Sep 2009 09:18:44 +0800
From: Alek Du <alek.du@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "david-b@pacbell.net" <david-b@pacbell.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] gpio: add Intel Moorestown Platform Langwell chip
 gpio driver
Message-ID: <20090918091844.6c8a8bd1@dxy.sh.intel.com>
In-Reply-To: <20090917163644.4783a337.akpm@linux-foundation.org>
References: <20090703210706.41288a2a@dxy.sh.intel.com>
	<20090917163644.4783a337.akpm@linux-foundation.org>
Organization: Intel Corp.
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.1; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Sorry for the inconvenience. I do not have SPARC64 build env., but I think this patch will fix the build issue, I should include <linux/irq.h> by explicit.

>From 5f0f166b37c4313c27de32f6f200bbd0656603b7 Mon Sep 17 00:00:00 2001
From: Alek Du <alek.du@intel.com>
Date: Fri, 18 Sep 2009 09:09:19 +0800
Subject: [PATCH] gpio: Fix Langwell gpio driver build error

Need to include <linux/irq.h> directly ...

Signed-off-by: Alek Du <alek.du@intel.com>
---
 drivers/gpio/langwell_gpio.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/langwell_gpio.c b/drivers/gpio/langwell_gpio.c
index e100583..10a1172 100644
--- a/drivers/gpio/langwell_gpio.c
+++ b/drivers/gpio/langwell_gpio.c
@@ -27,6 +27,7 @@
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <linux/irq.h>
 #include <linux/gpio.h>
 
 struct lnw_gpio_register {
-- 
1.6.0.4


On Fri, 18 Sep 2009 07:36:44 +0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 3 Jul 2009 21:07:06 +0800
> Alek Du <alek.du@intel.com> wrote:
> 
> > Changes from v2:
> > 1. Add missed MODULE_DEVICE_TABLE
> > 
> > Changes from v1:
> > 1. driver name changed from lnw.c ==> langwell_gpio.c
> > 2. removed hard coded driver data, now we get it from PCI bar1 (platform init code fills it)
> > 3. removed alternative function setting code, it should be called in platform init part.
> > 4. misc. style clean
> > 
> > 
> > >From 8eaad3aac8cffda193adcfc4b9fcbb7c461fd4b9 Mon Sep 17 00:00:00 2001
> > From: Alek Du <alek.du@intel.com>
> > Date: Tue, 30 Jun 2009 12:13:27 +0800
> > Subject: [PATCH] gpio: add Intel Moorestown Platform Langwell chip gpio driver
> > 
> > The Langwell chip is the IO hub for Intel Moorestown platform which has a
> > 64-pin gpio block device inside. It is exposed as a dedicated PCI device.
> > We use it to control outside peripheral as well as to do IRQ demuxing. The
> > gpio block uses MSI to send level type interrupt to IOAPIC.
> 
> sparc64 allmodconfig:
> 
> drivers/gpio/langwell_gpio.c: In function `lnw_irq_type':
> drivers/gpio/langwell_gpio.c:117: error: implicit declaration of function `get_irq_chip_data'
> drivers/gpio/langwell_gpio.c:117: warning: initialization makes pointer from integer without a cast
> drivers/gpio/langwell_gpio.c:128: error: `IRQ_TYPE_EDGE_RISING' undeclared (first use in this function)
> drivers/gpio/langwell_gpio.c:128: error: (Each undeclared identifier is reported only once
> drivers/gpio/langwell_gpio.c:128: error: for each function it appears in.)
> drivers/gpio/langwell_gpio.c:134: error: `IRQ_TYPE_EDGE_FALLING' undeclared (first use in this function)
> drivers/gpio/langwell_gpio.c: In function `lnw_irq_unmask':
> drivers/gpio/langwell_gpio.c:146: warning: initialization makes pointer from integer without a cast
> drivers/gpio/langwell_gpio.c: At top level:
> drivers/gpio/langwell_gpio.c:159: error: variable `lnw_irqchip' has initializer but incomplete type
> drivers/gpio/langwell_gpio.c:160: error: unknown field `name' specified in initializer
> drivers/gpio/langwell_gpio.c:160: warning: excess elements in struct initializer
> drivers/gpio/langwell_gpio.c:160: warning: (near initialization for `lnw_irqchip')
> drivers/gpio/langwell_gpio.c:161: error: unknown field `mask' specified in initializer
> drivers/gpio/langwell_gpio.c:161: warning: excess elements in struct initializer
> drivers/gpio/langwell_gpio.c:161: warning: (near initialization for `lnw_irqchip')
> drivers/gpio/langwell_gpio.c:162: error: unknown field `unmask' specified in initializer
> drivers/gpio/langwell_gpio.c:162: warning: excess elements in struct initializer
> drivers/gpio/langwell_gpio.c:162: warning: (near initialization for `lnw_irqchip')
> drivers/gpio/langwell_gpio.c:163: error: unknown field `set_type' specified in initializer
> drivers/gpio/langwell_gpio.c:163: warning: excess elements in struct initializer
> drivers/gpio/langwell_gpio.c:163: warning: (near initialization for `lnw_irqchip')
> drivers/gpio/langwell_gpio.c: In function `lnw_irq_handler':
> drivers/gpio/langwell_gpio.c:174: error: implicit declaration of function `get_irq_data'
> drivers/gpio/langwell_gpio.c:174: warning: cast to pointer from integer of different size
> drivers/gpio/langwell_gpio.c:189: error: implicit declaration of function `generic_handle_irq'
> drivers/gpio/langwell_gpio.c:195: error: dereferencing pointer to incomplete type
> drivers/gpio/langwell_gpio.c: In function `lnw_gpio_probe':
> drivers/gpio/langwell_gpio.c:263: error: implicit declaration of function `set_irq_data'
> drivers/gpio/langwell_gpio.c:264: error: implicit declaration of function `set_irq_chained_handler'
> drivers/gpio/langwell_gpio.c:266: error: implicit declaration of function `set_irq_chip_and_handler_name'
> drivers/gpio/langwell_gpio.c:267: error: `handle_simple_irq' undeclared (first use in this function)
> drivers/gpio/langwell_gpio.c:268: error: implicit declaration of function `set_irq_chip_data'
> drivers/gpio/langwell_gpio.c: At top level:
> drivers/gpio/langwell_gpio.c:159: error: storage size of `lnw_irqchip' isn't known
> 
