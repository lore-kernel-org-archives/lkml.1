Return-Path: <linux-kernel-owner+w=401wt.eu-S1756473AbZBST6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473AbZBST6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 14:58:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbZBST6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 14:58:41 -0500
Received: from rv-out-0506.google.com ([209.85.198.227]:13294 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbZBST6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 14:58:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=PuYre6PyAD3A21f9ef38U4KYCbyY+wdV+dJcBBo6U0OlmFe2U0wR/Vb0Ho5JbG7XAL
         nIL/9SYwINOs1VnFmFLPctyd8mlMITsUbGP6JwbWDfpLea0zvXmpLLcnOApYsiCCPCK5
         twEZKrYPxuuLdhvm4TTjNU/ajnrTrdvw6XkD0=
Subject: [PATCH] sound: pcxhr.h replace signed one-bit bitfields
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 19 Feb 2009 11:58:37 -0800
Message-Id: <1235073517.4377.5.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage and comments make it clear values of 1/0 were intended
rather than -1/0

Noticed by sparse:
sound/pci/pcxhr/pcxhr.h:100:20: error: dubious one-bit signed bitfield
sound/pci/pcxhr/pcxhr.h:101:22: error: dubious one-bit signed bitfield
sound/pci/pcxhr/pcxhr.h:102:24: error: dubious one-bit signed bitfield
sound/pci/pcxhr/pcxhr.h:103:21: error: dubious one-bit signed bitfield
sound/pci/pcxhr/pcxhr.h:104:25: error: dubious one-bit signed bitfield
sound/pci/pcxhr/pcxhr.h:105:20: error: dubious one-bit signed bitfield

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 sound/pci/pcxhr/pcxhr.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/pci/pcxhr/pcxhr.h b/sound/pci/pcxhr/pcxhr.h
index ac9c3b3..a661a18 100644
--- a/sound/pci/pcxhr/pcxhr.h
+++ b/sound/pci/pcxhr/pcxhr.h
@@ -97,12 +97,12 @@ struct pcxhr_mgr {
 	int capture_chips;
 	int fw_file_set;
 	int firmware_num;
-	int is_hr_stereo:1;
-	int board_has_aes1:1;	/* if 1 board has AES1 plug and SRC */
-	int board_has_analog:1;	/* if 0 the board is digital only */
-	int board_has_mic:1;	/* if 1 the board has microphone input */
-	int board_aes_in_192k:1;/* if 1 the aes input plugs do support 192kHz */
-	int mono_capture:1;	/* if 1 the board does mono capture */
+	unsigned int is_hr_stereo:1;
+	unsigned int board_has_aes1:1;	/* if 1 board has AES1 plug and SRC */
+	unsigned int board_has_analog:1;	/* if 0 the board is digital only */
+	unsigned int board_has_mic:1;	/* if 1 the board has microphone input */
+	unsigned int board_aes_in_192k:1;/* if 1 the aes input plugs do support 192kHz */
+	unsigned int mono_capture:1;	/* if 1 the board does mono capture */
 
 	struct snd_dma_buffer hostport;
 
-- 
1.6.2.rc1.175.g96b8a



