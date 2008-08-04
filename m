Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbYHDJ5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbYHDJ5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 05:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748AbYHDJ5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 05:57:22 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:7382 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbYHDJ5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 05:57:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=rrkMknbnY3asyTGhAgBnImygH/Pt8x5+M65oAkhlvg/0aO5UA+MfUXHitNrdNECNj3
         k3JNu1ws7iB73dI1WOY28YX5cCgX/i2KmrXiLeyXaw/UpJ0DRcJE+osjN5Okv7yM+1dU
         ng1TV20ZjVM/fsjY3kMdcjqDXsuH83IZ1HGDs=
Date: Mon, 4 Aug 2008 17:57:18 +0800
From: "peerchen" <peerchen@gmail.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "alsa-devel" <alsa-devel@alsa-project.org>
Cc: "akpm" <akpm@linux-foundation.org>, "pchen" <pchen@nvidia.com>
Subject: [alsa-devel][PATCH] hda_intel: enable snoop for nvidia HDA controller
Message-ID: <200808041757132250842@gmail.com>
X-mailer: Foxmail 6, 10, 201, 20 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the snoop for nvidia hda controller to avoid data coherence issue.

Signed-off-by: Peer Chen <peerchen@gmail.com>
---
--- linux-2.6.27-rc1/sound/pci/hda/hda_intel.c.orig	2008-08-01 14:14:54.000000000 -0400
+++ linux-2.6.27-rc1/sound/pci/hda/hda_intel.c	2008-08-01 14:31:38.000000000 -0400
@@ -277,6 +277,9 @@ enum {
 /* Defines for Nvidia HDA support */
 #define NVIDIA_HDA_TRANSREG_ADDR      0x4e
 #define NVIDIA_HDA_ENABLE_COHBITS     0x0f
+#define NVIDIA_HDA_ISTRM_COH          0x4d
+#define NVIDIA_HDA_OSTRM_COH          0x4c
+#define NVIDIA_HDA_ENABLE_COHBIT      0x01
 
 /* Defines for Intel SCH HDA snoop control */
 #define INTEL_SCH_HDA_DEVC      0x78
@@ -899,6 +902,12 @@ static void azx_init_pci(struct azx *chi
 		update_pci_byte(chip->pci,
 				NVIDIA_HDA_TRANSREG_ADDR,
 				0x0f, NVIDIA_HDA_ENABLE_COHBITS);
+		update_pci_byte(chip->pci,
+				NVIDIA_HDA_ISTRM_COH,
+				0x01, NVIDIA_HDA_ENABLE_COHBIT);
+		update_pci_byte(chip->pci,
+				NVIDIA_HDA_OSTRM_COH,
+				0x01, NVIDIA_HDA_ENABLE_COHBIT);				
 		break;
 	case AZX_DRIVER_SCH:
 		pci_read_config_word(chip->pci, INTEL_SCH_HDA_DEVC, &snoop);
-

