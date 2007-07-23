Return-Path: <linux-kernel-owner+w=401wt.eu-S1763412AbXGWOwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763412AbXGWOwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 10:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762943AbXGWOvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 10:51:51 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:42143 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762866AbXGWOvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 10:51:50 -0400
Date: Mon, 23 Jul 2007 16:51:16 +0200
From: Adrian Bunk <bunk@stusta.de>
To: perex@suse.cz
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] sound/pci/cs46xx/: fix an off-by-one
Message-ID: <20070723145116.GL26212@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an off-by-one in a snd_assert() spotted by the 
Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6-mm1/sound/pci/cs46xx/dsp_spos_scb_lib.c.old	2007-07-23 15:33:17.000000000 +0200
+++ linux-2.6.22-rc6-mm1/sound/pci/cs46xx/dsp_spos_scb_lib.c	2007-07-23 15:33:37.000000000 +0200
@@ -1480,7 +1480,7 @@ void cs46xx_dsp_destroy_pcm_channel (str
 	if (!pcm_channel->src_scb->ref_count) {
 		cs46xx_dsp_remove_scb(chip,pcm_channel->src_scb);
 
-		snd_assert (pcm_channel->src_slot >= 0 && pcm_channel->src_slot <= DSP_MAX_SRC_NR,
+		snd_assert (pcm_channel->src_slot >= 0 && pcm_channel->src_slot < DSP_MAX_SRC_NR,
 			    return );
 
 		ins->src_scb_slots[pcm_channel->src_slot] = 0;

