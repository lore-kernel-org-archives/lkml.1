Return-Path: <linux-kernel-owner+w=401wt.eu-S1754150AbZIQXgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbZIQXgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 19:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbZIQXgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 19:36:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58374 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753887AbZIQXgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 19:36:46 -0400
Date: Thu, 17 Sep 2009 16:36:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alek Du <alek.du@intel.com>
Cc: david-b@pacbell.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] gpio: add Intel Moorestown Platform Langwell chip
 gpio driver
Message-Id: <20090917163644.4783a337.akpm@linux-foundation.org>
In-Reply-To: <20090703210706.41288a2a@dxy.sh.intel.com>
References: <20090703210706.41288a2a@dxy.sh.intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jul 2009 21:07:06 +0800
Alek Du <alek.du@intel.com> wrote:

> Changes from v2:
> 1. Add missed MODULE_DEVICE_TABLE
> 
> Changes from v1:
> 1. driver name changed from lnw.c ==> langwell_gpio.c
> 2. removed hard coded driver data, now we get it from PCI bar1 (platform init code fills it)
> 3. removed alternative function setting code, it should be called in platform init part.
> 4. misc. style clean
> 
> 
> >From 8eaad3aac8cffda193adcfc4b9fcbb7c461fd4b9 Mon Sep 17 00:00:00 2001
> From: Alek Du <alek.du@intel.com>
> Date: Tue, 30 Jun 2009 12:13:27 +0800
> Subject: [PATCH] gpio: add Intel Moorestown Platform Langwell chip gpio driver
> 
> The Langwell chip is the IO hub for Intel Moorestown platform which has a
> 64-pin gpio block device inside. It is exposed as a dedicated PCI device.
> We use it to control outside peripheral as well as to do IRQ demuxing. The
> gpio block uses MSI to send level type interrupt to IOAPIC.

sparc64 allmodconfig:

drivers/gpio/langwell_gpio.c: In function `lnw_irq_type':
drivers/gpio/langwell_gpio.c:117: error: implicit declaration of function `get_irq_chip_data'
drivers/gpio/langwell_gpio.c:117: warning: initialization makes pointer from integer without a cast
drivers/gpio/langwell_gpio.c:128: error: `IRQ_TYPE_EDGE_RISING' undeclared (first use in this function)
drivers/gpio/langwell_gpio.c:128: error: (Each undeclared identifier is reported only once
drivers/gpio/langwell_gpio.c:128: error: for each function it appears in.)
drivers/gpio/langwell_gpio.c:134: error: `IRQ_TYPE_EDGE_FALLING' undeclared (first use in this function)
drivers/gpio/langwell_gpio.c: In function `lnw_irq_unmask':
drivers/gpio/langwell_gpio.c:146: warning: initialization makes pointer from integer without a cast
drivers/gpio/langwell_gpio.c: At top level:
drivers/gpio/langwell_gpio.c:159: error: variable `lnw_irqchip' has initializer but incomplete type
drivers/gpio/langwell_gpio.c:160: error: unknown field `name' specified in initializer
drivers/gpio/langwell_gpio.c:160: warning: excess elements in struct initializer
drivers/gpio/langwell_gpio.c:160: warning: (near initialization for `lnw_irqchip')
drivers/gpio/langwell_gpio.c:161: error: unknown field `mask' specified in initializer
drivers/gpio/langwell_gpio.c:161: warning: excess elements in struct initializer
drivers/gpio/langwell_gpio.c:161: warning: (near initialization for `lnw_irqchip')
drivers/gpio/langwell_gpio.c:162: error: unknown field `unmask' specified in initializer
drivers/gpio/langwell_gpio.c:162: warning: excess elements in struct initializer
drivers/gpio/langwell_gpio.c:162: warning: (near initialization for `lnw_irqchip')
drivers/gpio/langwell_gpio.c:163: error: unknown field `set_type' specified in initializer
drivers/gpio/langwell_gpio.c:163: warning: excess elements in struct initializer
drivers/gpio/langwell_gpio.c:163: warning: (near initialization for `lnw_irqchip')
drivers/gpio/langwell_gpio.c: In function `lnw_irq_handler':
drivers/gpio/langwell_gpio.c:174: error: implicit declaration of function `get_irq_data'
drivers/gpio/langwell_gpio.c:174: warning: cast to pointer from integer of different size
drivers/gpio/langwell_gpio.c:189: error: implicit declaration of function `generic_handle_irq'
drivers/gpio/langwell_gpio.c:195: error: dereferencing pointer to incomplete type
drivers/gpio/langwell_gpio.c: In function `lnw_gpio_probe':
drivers/gpio/langwell_gpio.c:263: error: implicit declaration of function `set_irq_data'
drivers/gpio/langwell_gpio.c:264: error: implicit declaration of function `set_irq_chained_handler'
drivers/gpio/langwell_gpio.c:266: error: implicit declaration of function `set_irq_chip_and_handler_name'
drivers/gpio/langwell_gpio.c:267: error: `handle_simple_irq' undeclared (first use in this function)
drivers/gpio/langwell_gpio.c:268: error: implicit declaration of function `set_irq_chip_data'
drivers/gpio/langwell_gpio.c: At top level:
drivers/gpio/langwell_gpio.c:159: error: storage size of `lnw_irqchip' isn't known

