Return-Path: <linux-kernel-owner+w=401wt.eu-S934099AbYBMWMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934099AbYBMWMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:12:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763063AbYBMWMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:12:23 -0500
Received: from styx.suse.cz ([82.119.242.94]:56435 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761330AbYBMWMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:12:21 -0500
Date: Wed, 13 Feb 2008 23:12:20 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
cc: David Sterba <dsterba@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] ipwireless: remove unused debugging functions (was Re: [2.6
 patch] #if 0 ipwireless_dump_{hardware,network}_state())
In-Reply-To: <20080213213004.GU3383@cs181133002.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0802132307470.30955@jikos.suse.cz>
References: <20080213213004.GU3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Adrian Bunk wrote:

> This patch #if 0's the unused ipwireless_dump_{hardware,network}_state().
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Adrian,

I'd rather remove it completely. Thanks for noticing this.


From: Jiri Kosina <jkosina@suse.cz>

Remove unused leftovers of debugging functions. Noticed by Adrian Bunk.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/drivers/char/pcmcia/ipwireless/hardware.c b/drivers/char/pcmcia/ipwireless/hardware.c
index 1f978ff..fa9d3c9 100644
--- a/drivers/char/pcmcia/ipwireless/hardware.c
+++ b/drivers/char/pcmcia/ipwireless/hardware.c
@@ -354,32 +354,6 @@ struct ipw_rx_packet {
 	unsigned int channel_idx;
 };
 
-#ifdef IPWIRELESS_STATE_DEBUG
-int ipwireless_dump_hardware_state(char *p, size_t limit,
-				   struct ipw_hardware *hw)
-{
-	return snprintf(p, limit,
-			"debug: initializing=%d\n"
-			"debug: tx_ready=%d\n"
-			"debug: tx_queued=%d\n"
-			"debug: rx_ready=%d\n"
-			"debug: rx_bytes_queued=%d\n"
-			"debug: blocking_rx=%d\n"
-			"debug: removed=%d\n"
-			"debug: hardware.shutting_down=%d\n"
-			"debug: to_setup=%d\n",
-			hw->initializing,
-			hw->tx_ready,
-			hw->tx_queued,
-			hw->rx_ready,
-			hw->rx_bytes_queued,
-			hw->blocking_rx,
-			hw->removed,
-			hw->shutting_down,
-			hw->to_setup);
-}
-#endif
-
 static char *data_type(const unsigned char *buf, unsigned length)
 {
 	struct nl_packet_header *hdr = (struct nl_packet_header *) buf;
diff --git a/drivers/char/pcmcia/ipwireless/hardware.h b/drivers/char/pcmcia/ipwireless/hardware.h
index c83190f..19ce5eb 100644
--- a/drivers/char/pcmcia/ipwireless/hardware.h
+++ b/drivers/char/pcmcia/ipwireless/hardware.h
@@ -58,7 +58,5 @@ void ipwireless_init_hardware_v1(struct ipw_hardware *hw,
 				 void *reboot_cb_data);
 void ipwireless_init_hardware_v2_v3(struct ipw_hardware *hw);
 void ipwireless_sleep(unsigned int tenths);
-int ipwireless_dump_hardware_state(char *p, size_t limit,
-				   struct ipw_hardware *hw);
 
 #endif
diff --git a/drivers/char/pcmcia/ipwireless/network.c b/drivers/char/pcmcia/ipwireless/network.c
index ff35230..6e189ed 100644
--- a/drivers/char/pcmcia/ipwireless/network.c
+++ b/drivers/char/pcmcia/ipwireless/network.c
@@ -63,21 +63,6 @@ struct ipw_network {
 	struct work_struct work_go_offline;
 };
 
-
-#ifdef IPWIRELESS_STATE_DEBUG
-int ipwireless_dump_network_state(char *p, size_t limit,
-				  struct ipw_network *network)
-{
-	return snprintf(p, limit,
-			"debug: ppp_blocked=%d\n"
-			"debug: outgoing_packets_queued=%d\n"
-			"debug: network.shutting_down=%d\n",
-			network->ppp_blocked,
-			network->outgoing_packets_queued,
-			network->shutting_down);
-}
-#endif
-
 static void notify_packet_sent(void *callback_data, unsigned int packet_length)
 {
 	struct ipw_network *network = callback_data;
diff --git a/drivers/char/pcmcia/ipwireless/network.h b/drivers/char/pcmcia/ipwireless/network.h
index b0e1e95..ccacd26 100644
--- a/drivers/char/pcmcia/ipwireless/network.h
+++ b/drivers/char/pcmcia/ipwireless/network.h
@@ -49,7 +49,4 @@ void ipwireless_ppp_close(struct ipw_network *net);
 int ipwireless_ppp_channel_index(struct ipw_network *net);
 int ipwireless_ppp_unit_number(struct ipw_network *net);
 
-int ipwireless_dump_network_state(char *p, size_t limit,
-				  struct ipw_network *net);
-
 #endif
