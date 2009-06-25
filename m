Return-Path: <linux-kernel-owner+w=401wt.eu-S1759708AbZFYGck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708AbZFYGck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 02:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbZFYGcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 02:32:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39601 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076AbZFYGcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 02:32:31 -0400
Date: Thu, 25 Jun 2009 08:32:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Baruch Siach <baruch@tkos.co.il>, Ben Dooks <ben-linux@fluff.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] i2c: fix build bug in i2c-designware.c
Message-ID: <20090625063221.GA17798@elte.hu>
References: <alpine.LFD.2.01.0906241656030.3605@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906241656030.3605@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Find below a minor build fix for a new ARM-only driver.

	Ingo

--------------->
>From 8bf467c9f4591f77e1d69bd78fb6cc4f1ff387f8 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 25 Jun 2009 08:27:14 +0200
Subject: [PATCH] i2c: fix build bug in i2c-designware.c

This build error triggers on x86:

 drivers/built-in.o: In function `i2c_dw_init':
 i2c-designware.c:(.text+0x4e37ca): undefined reference to `clk_get_rate'
 drivers/built-in.o: In function `dw_i2c_probe':
 i2c-designware.c:(.devinit.text+0x51f5e): undefined reference to `clk_get'
 i2c-designware.c:(.devinit.text+0x51f76): undefined reference to `clk_enable'
 i2c-designware.c:(.devinit.text+0x520ff): undefined reference to `clk_disable'
 i2c-designware.c:(.devinit.text+0x52108): undefined reference to `clk_put'

Because this new driver uses the clk_*() facilities which is an
ARM-only thing currently.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/i2c/busses/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index d56351a..0760f25 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -334,6 +334,7 @@ config I2C_DAVINCI
 
 config I2C_DESIGNWARE
 	tristate "Synopsys DesignWare"
+	depends on HAVE_CLK
 	help
 	  If you say yes to this option, support will be included for the
 	  Synopsys DesignWare I2C adapter. Only master mode is supported.

