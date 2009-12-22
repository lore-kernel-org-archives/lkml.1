Return-Path: <linux-kernel-owner+w=401wt.eu-S1752426AbZLVAja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbZLVAja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 19:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbZLVAja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 19:39:30 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:36375 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbZLVAj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 19:39:29 -0500
Subject: [PATCH] m68knommu: Fix invalid flags on coldfire pit clocksource
From: john stultz <johnstul@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Ungerer <gerg@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven King <sfking@fdwdc.com>
In-Reply-To: <200912181920.12905.sfking@fdwdc.com>
References: <200912181813.44220.sfking@fdwdc.com>
	 <1f1b08da0912181844u4f7e66a7ue30287208d075327@mail.gmail.com>
	 <200912181920.12905.sfking@fdwdc.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Dec 2009 16:39:18 -0800
Message-ID: <1261442358.5293.50.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just re-sending this in case it was missed. Steven tested this and it
seems to be the right fix. Should be 2.6.33 material.

thanks
-john



The m68knommu coldfire pit clocksource looks like it was incorrectly
marked as a continuous clocksource. Running with it marked as a
continuous clocksource could cause hangs when the system switches to
highres mode or enables nohz.

This patch removes the CLOCK_SOURCE_IS_CONTINUOUS flag on the coldfire
pit clocksource. This will disallow systems using this clocksource from
entering oneshot mode (disabling highres timers and nohz).

Signed-off-by: John Stultz <johnstul@us.ibm.com>

---

diff --git a/arch/m68knommu/platform/coldfire/pit.c b/arch/m68knommu/platform/coldfire/pit.c
index d8720ee..aebea19 100644
--- a/arch/m68knommu/platform/coldfire/pit.c
+++ b/arch/m68knommu/platform/coldfire/pit.c
@@ -146,7 +146,6 @@ static struct clocksource pit_clk = {
 	.read	= pit_read_clk,
 	.shift	= 20,
 	.mask	= CLOCKSOURCE_MASK(32),
-	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 /***************************************************************************/



