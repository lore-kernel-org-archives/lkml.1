Return-Path: <linux-kernel-owner+w=401wt.eu-S1757152AbZJVWMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152AbZJVWMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 18:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756977AbZJVWMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 18:12:17 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:55712 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757122AbZJVWMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 18:12:13 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.160.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+EfxFafzpnfZkr8LYq102F
Subject: [PATCH 05/10] omap1: Fix DSP public peripherals support for ams-delta
To: linux-arm-kernel@lists.infradead.org
From: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
       Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Date: Thu, 22 Oct 2009 15:12:16 -0700
Message-ID: <20091022221216.27408.39863.stgit@localhost>
In-Reply-To: <20091022221013.27408.443.stgit@localhost>
References: <20091022221013.27408.443.stgit@localhost>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>

DSP public peripherals used to work on OMAP1510 based (or all OMAP1 class?)
machines as long as old dspgateway code were present in the l-o tree. For
several months it is no longer included, breaking support for McBSP1 based
audio on Amstrad Delta, for example.

This patch, derived from the old dspgateway code, corrects the problem for the
board by simply taking the DSP out of reset state, I guess. That way, things
should not break when a new dsp code is added to the tree, and the change can
be reverted then.

If there are any reports on McBSP1 or other DSP public peripherals not working
for other OMAP1 machines (I've not heard of any for now), I can prepare a more
general patch providing an extra include file with a helper function defined.

Created and tested against linux-2.6.32-rc5

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/board-ams-delta.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap1/board-ams-delta.c b/arch/arm/mach-omap1/board-ams-delta.c
index 972499e..8ad5cc3 100644
--- a/arch/arm/mach-omap1/board-ams-delta.c
+++ b/arch/arm/mach-omap1/board-ams-delta.c
@@ -235,6 +235,8 @@ static void __init ams_delta_init(void)
 
 	omap_usb_init(&ams_delta_usb_config);
 	platform_add_devices(ams_delta_devices, ARRAY_SIZE(ams_delta_devices));
+
+	omap_writew(omap_readw(ARM_RSTCT1) | 0x0004, ARM_RSTCT1);
 }
 
 static struct plat_serial8250_port ams_delta_modem_ports[] = {

