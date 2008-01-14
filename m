Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbYANW6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbYANW6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 17:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbYANW6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 17:58:31 -0500
Received: from fw1-az.mvista.com ([65.200.49.156]:34779 "EHLO
	zipcode.az.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755393AbYANW6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:58:30 -0500
X-Greylist: delayed 468 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jan 2008 17:58:30 EST
Date: Mon, 14 Jan 2008 15:47:11 -0700
From: "Mark A. Greer" <mgreer@mvista.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] Serial: MPSC - Set baudrate when BRG divider is set.
Message-ID: <20080114224711.GA21940@mag.az.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark A. Greer <mgreer@mvista.com>

The clock to generate the desired baudrate with the MPSC is first divided
by the Baud Rate Generator (BRG) and then by the MPSC itself.  So, when
the BRG divider is changed, the MPSC divider must also be changed to
generate the correct baudrate.  During MPSC initialization, the BRG
divider is changed but the MPSC divider isn't changed until much later.
This results in some printk's coming out garbled.  To fix that, set the
MPSC divider at the same time that the BRG divider is changed.

Signed-off-by: Mark A. Greer <mgreer@mvista.com
---
 drivers/serial/mpsc.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/serial/mpsc.c b/drivers/serial/mpsc.c
index 4d643c9..cb3a919 100644
--- a/drivers/serial/mpsc.c
+++ b/drivers/serial/mpsc.c
@@ -612,6 +612,7 @@ static void mpsc_hw_init(struct mpsc_port_info *pi)
 
 	/* No preamble, 16x divider, low-latency, */
 	writel(0x04400400, pi->mpsc_base + MPSC_MMCRH);
+	mpsc_set_baudrate(pi, pi->default_baud);
 
 	if (pi->mirror_regs) {
 		pi->MPSC_CHR_1_m = 0;
