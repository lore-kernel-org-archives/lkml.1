Return-Path: <linux-kernel-owner+w=401wt.eu-S934754AbZLGMdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934754AbZLGMdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 07:33:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934728AbZLGMdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 07:33:12 -0500
Received: from mail.southpole.se ([193.12.106.18]:34269 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934727AbZLGMdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 07:33:12 -0500
X-Greylist: delayed 1329 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Dec 2009 07:33:12 EST
Subject: gpio gpio_to_irq
From: Kenneth Johansson <kenneth@southpole.se>
To: linux-kernel@vger.kernel.org
Cc: alek.du@intel.com, david-b@pacbell.net, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Dec 2009 13:11:07 +0100
Message-ID: <1260187867.16040.35.camel@kenjo-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a few questions regarding the gpio related to interrupts.

The hardware is a generic gpio block that is located on pci. The pins
themselves can be configured to in/out and generate interrupts.

All in all it looks to be very similar to the langwell gpio. 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/gpio/langwell_gpio.c;h=4baf3d7d0f8e6e4f1f7887625b7f73a62dba1a83;hb=22763c5cf3690a681551162c15d34d935308c8d7


Many gpio drivers use the set_irq_chained_handler() instead of calling
request_irq to get the main gpio interrupt. But doing so on a shared pci
interrupt do not look like a good idea. 

Under what circumstance is set_irq_chained_handler allowed ? 

The next thing is that the drivers then registers a "fake" interrupt
chip to make it possible for the gpio client to call request_irq with
the irq number returned from gpio_to_irq().

While using this interface is neat it do require that the gpio driver
somehow can just take over a few irq numbers from the system. 

How is this supposed to be done?? the langwell driver reads a number
located at BAR1 and simply use that as the first irq number, hu?

others start to allocate from the top and so on. what is the correct way
to do this on a x86 with a gpio device on the pci bus ?? 



