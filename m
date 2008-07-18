Return-Path: <linux-kernel-owner+w=401wt.eu-S1760424AbYGRWMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760424AbYGRWMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759339AbYGRWLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:11:17 -0400
Received: from styx.suse.cz ([82.119.242.94]:55500 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758608AbYGRWLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:11:16 -0400
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 04/12] ipwireless: Remove pt_regs from interrupt handler
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dsterba@suse.cz, jkosina@suse.cz
Date: Sat, 19 Jul 2008 00:11:15 +0200
Message-ID: <20080718221114.19195.2995.stgit@ds.suse.cz>
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

 drivers/char/pcmcia/ipwireless/hardware.c |    2 +-
 drivers/char/pcmcia/ipwireless/hardware.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/pcmcia/ipwireless/hardware.c b/drivers/char/pcmcia/ipwireless/hardware.c
index f948791..0ccbbc1 100644
--- a/drivers/char/pcmcia/ipwireless/hardware.c
+++ b/drivers/char/pcmcia/ipwireless/hardware.c
@@ -1196,7 +1196,7 @@ static irqreturn_t ipwireless_handle_v2_v3_interrupt(int irq,
 	return IRQ_HANDLED;
 }
 
-irqreturn_t ipwireless_interrupt(int irq, void *dev_id, struct pt_regs *regs)
+irqreturn_t ipwireless_interrupt(int irq, void *dev_id)
 {
 	struct ipw_hardware *hw = dev_id;
 
diff --git a/drivers/char/pcmcia/ipwireless/hardware.h b/drivers/char/pcmcia/ipwireless/hardware.h
index 19ce5eb..e21d23a 100644
--- a/drivers/char/pcmcia/ipwireless/hardware.h
+++ b/drivers/char/pcmcia/ipwireless/hardware.h
@@ -34,7 +34,7 @@ struct ipw_network;
 
 struct ipw_hardware *ipwireless_hardware_create(void);
 void ipwireless_hardware_free(struct ipw_hardware *hw);
-irqreturn_t ipwireless_interrupt(int irq, void *dev_id, struct pt_regs *regs);
+irqreturn_t ipwireless_interrupt(int irq, void *dev_id);
 int ipwireless_set_DTR(struct ipw_hardware *hw, unsigned int channel_idx,
 		int state);
 int ipwireless_set_RTS(struct ipw_hardware *hw, unsigned int channel_idx,

