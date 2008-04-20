Return-Path: <linux-kernel-owner+w=401wt.eu-S1757564AbYDTKCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbYDTKCB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbYDTKBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:01:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34486
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754540AbYDTKBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:01:40 -0400
Date: Sun, 20 Apr 2008 03:01:41 -0700 (PDT)
Message-Id: <20080420.030141.07052649.davem@davemloft.net>
To: ivdoorn@gmail.com
Cc: mingo@elte.hu, linville@tuxdriver.com, tomas.winkler@intel.com,
       linux-kernel@vger.kernel.org, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
       mabbas@linux.intel.com, ischram@telenet.be, rjw@sisk.pl
Subject: Re: [build bug] drivers/built-in.o: In function
 `rt2x00leds_resume': : undefined reference to `led_classdev_resume'
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080420.024704.02026708.davem@davemloft.net>
References: <20080420.020557.231970202.davem@davemloft.net>
	<200804201131.01504.IvDoorn@gmail.com>
	<20080420.024704.02026708.davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sun, 20 Apr 2008 02:47:04 -0700 (PDT)

> I think NEW_LEDS can be completely eliminated.

Actually, more accurately, I propose removing the HAS_IOMEM
restriction.

This allows LEDS infrastructure to be select'd by drivers safely.

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 859814f..91d36d0 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -1,6 +1,5 @@
 menuconfig NEW_LEDS
 	bool "LED Support"
-	depends on HAS_IOMEM
 	help
 	  Say Y to enable Linux LED support.  This allows control of supported
 	  LEDs from both userspace and optionally, by kernel events (triggers).
