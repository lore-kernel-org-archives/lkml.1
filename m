Return-Path: <linux-kernel-owner+w=401wt.eu-S932190AbXDEHZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbXDEHZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 03:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932306AbXDEHZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 03:25:05 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:11632 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932190AbXDEHZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 03:25:03 -0400
X-IronPort-AV: i="4.14,373,1170651600"; 
   d="scan'208"; a="26404443:sNHT22997240"
Subject: [PATCH] blackfin arch: fix bug asserting gpio requested doesnt
	make sense with GPIO whole PORT accesses
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Thu, 05 Apr 2007 15:26:45 +0800
Message-Id: <1175758005.17315.48.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] blackfin arch:
A BUG_ON will fire in the STAMP533 board when enable ethernet support.
This BUG_ON asserting is useless in the whole PORT accesses. So remove
it.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/kernel/bfin_gpio.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/kernel/bfin_gpio.c b/arch/blackfin/kernel/bfin_gpio.c
index bb71aaf..e9f24a9 100644
--- a/arch/blackfin/kernel/bfin_gpio.c
+++ b/arch/blackfin/kernel/bfin_gpio.c
@@ -316,7 +316,6 @@ SET_GPIO_P(maskb)
 void set_gpiop_data(unsigned short gpio, unsigned short arg)
 {
 	unsigned long flags;
-	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)));
 	local_irq_save(flags);
 	gpio_bankb[gpio_bank(gpio)]->data = arg;
 	bfin_read_CHIPID();
@@ -386,7 +385,6 @@ unsigned short get_gpiop_data(unsigned short gpio)
 {
 	unsigned long flags;
 	unsigned short ret;
-	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)));
 	local_irq_save(flags);
 	ret = gpio_bankb[gpio_bank(gpio)]->data;
 	bfin_read_CHIPID();
-- 
1.5.0.5

