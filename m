Return-Path: <linux-kernel-owner+w=401wt.eu-S1760670AbYGRWM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760670AbYGRWM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756085AbYGRWLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:11:22 -0400
Received: from styx.suse.cz ([82.119.242.94]:55526 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759430AbYGRWLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:11:21 -0400
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 05/12] ipwireless: Glue splitted printk strings back
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dsterba@suse.cz, jkosina@suse.cz
Date: Sat, 19 Jul 2008 00:11:20 +0200
Message-ID: <20080718221120.19195.77863.stgit@ds.suse.cz>
In-Reply-To: <20080718220840.19195.4140.stgit@ds.suse.cz>
References: <20080718220840.19195.4140.stgit@ds.suse.cz>
User-Agent: StGIT/0.14.3.173.g2e37
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---

 drivers/char/pcmcia/ipwireless/hardware.c |   15 +++++----------
 drivers/char/pcmcia/ipwireless/main.c     |   15 +++++++--------
 2 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/char/pcmcia/ipwireless/hardware.c b/drivers/char/pcmcia/ipwireless/hardware.c
index 0ccbbc1..7428734 100644
--- a/drivers/char/pcmcia/ipwireless/hardware.c
+++ b/drivers/char/pcmcia/ipwireless/hardware.c
@@ -79,8 +79,7 @@ static void report_timing(void)
 		timing_stats.last_report_time = jiffies;
 		if (!first)
 			printk(KERN_INFO IPWIRELESS_PCCARD_NAME
-			       ": %u us elapsed - read %lu bytes in %u us, "
-			       "wrote %lu bytes in %u us\n",
+			       ": %u us elapsed - read %lu bytes in %u us, wrote %lu bytes in %u us\n",
 			       jiffies_to_usecs(since),
 			       timing_stats.read_bytes,
 			       jiffies_to_usecs(timing_stats.read_time),
@@ -846,8 +845,7 @@ static void do_receive_packet(struct ipw_hardware *hw)
 		len = inw(hw->base_port + IODRR);
 		if (len > hw->ll_mtu) {
 			printk(KERN_INFO IPWIRELESS_PCCARD_NAME
-			       ": received a packet of %u bytes - "
-			       "longer than the MTU!\n", len);
+			       ": received a packet of %u bytes - longer than the MTU!\n", len);
 			outw(DCR_RXDONE | DCR_RXRESET, hw->base_port + IODCR);
 			return;
 		}
@@ -863,8 +861,7 @@ static void do_receive_packet(struct ipw_hardware *hw)
 		len = inw(hw->base_port);
 		if (len > hw->ll_mtu) {
 			printk(KERN_INFO IPWIRELESS_PCCARD_NAME
-			       ": received a packet of %u bytes - "
-			       "longer than the MTU!\n", len);
+			       ": received a packet of %u bytes - longer than the MTU!\n", len);
 			writew(MEMRX_PCINTACKK,
 				&hw->memory_info_regs->memreg_pc_interrupt_ack);
 			return;
@@ -1180,8 +1177,7 @@ static irqreturn_t ipwireless_handle_v2_v3_interrupt(int irq,
 					": spurious interrupt - new_tx mode\n");
 			else {
 				printk(KERN_WARNING IPWIRELESS_PCCARD_NAME
-					": no valid memreg_tx value - "
-					"switching to the old memreg_tx\n");
+					": no valid memreg_tx value - switching to the old memreg_tx\n");
 				hw->memreg_tx =
 					&hw->memory_info_regs->memreg_tx_old;
 				try_mem_tx_old = 1;
@@ -1487,8 +1483,7 @@ static void handle_setup_get_version_rsp(struct ipw_hardware *hw,
 	if (vers_no == TL_SETUP_VERSION)
 		__handle_setup_get_version_rsp(hw);
 	else
-		printk(KERN_ERR
-				IPWIRELESS_PCCARD_NAME
+		printk(KERN_ERR IPWIRELESS_PCCARD_NAME
 				": invalid hardware version no %u\n",
 				(unsigned int) vers_no);
 }
diff --git a/drivers/char/pcmcia/ipwireless/main.c b/drivers/char/pcmcia/ipwireless/main.c
index cc7dcea..6bdd11d 100644
--- a/drivers/char/pcmcia/ipwireless/main.c
+++ b/drivers/char/pcmcia/ipwireless/main.c
@@ -311,14 +311,13 @@ static int config_ipwireless(struct ipw_dev *ipw)
 			(unsigned int) link->irq.AssignedIRQ);
 	if (ipw->attr_memory && ipw->common_memory)
 		printk(KERN_INFO IPWIRELESS_PCCARD_NAME
-				": attr memory 0x%08lx-0x%08lx, "
-				"common memory 0x%08lx-0x%08lx\n",
-				request_attr_memory.Base,
-				request_attr_memory.Base
-				+ request_attr_memory.Size - 1,
-				request_common_memory.Base,
-				request_common_memory.Base
-				+ request_common_memory.Size - 1);
+			": attr memory 0x%08lx-0x%08lx, common memory 0x%08lx-0x%08lx\n",
+			request_attr_memory.Base,
+			request_attr_memory.Base
+			+ request_attr_memory.Size - 1,
+			request_common_memory.Base,
+			request_common_memory.Base
+			+ request_common_memory.Size - 1);
 
 	ipw->network = ipwireless_network_create(ipw->hardware);
 	if (!ipw->network)

