Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbXH3D27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbXH3D27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 23:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754470AbXH3D2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 23:28:51 -0400
Received: from mail.queued.net ([207.210.101.209]:1800 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244AbXH3D2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 23:28:50 -0400
Date: Wed, 29 Aug 2007 23:30:43 -0400
From: Andres Salomon <dilinger@queued.net>
To: jayakumar.alsa@gmail.com
Cc: akpm@linux-foundation.org, jordan.crouse@amd.com,
       linux-kernel@vger.kernel.org, info-linux@geode.amd.com
Subject: [PATCH 4/5] ALSA: cs5535audio: fix ACC_BM[x]_CMD register handling
Message-Id: <20070829233043.42d24ff7.dilinger@queued.net>
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ACcording to 6.3.2.7 of the cs5535/cs5536 data sheets, the ACC_BM[x]_CMD
registers are only 8 bits wide.  This driver treats them as 32 bits wide,
and also has bits in the wrong place.  Simple fix to the definitions.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---

 sound/pci/cs5535audio/cs5535audio.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/pci/cs5535audio/cs5535audio.h b/sound/pci/cs5535audio/cs5535audio.h
index c7a2044..516219a 100644
--- a/sound/pci/cs5535audio/cs5535audio.h
+++ b/sound/pci/cs5535audio/cs5535audio.h
@@ -62,11 +62,11 @@
 #define EOP				(1<<0)
 #define BM_EOP_ERR			(1<<1)
 /* ACC_BMX_CTL */
-#define BM_CTL_EN			0x00000001
-#define BM_CTL_PAUSE			0x00000011
-#define BM_CTL_DIS			0x00000000
-#define BM_CTL_BYTE_ORD_LE		0x00000000
-#define BM_CTL_BYTE_ORD_BE		0x00000100
+#define BM_CTL_EN			0x01
+#define BM_CTL_PAUSE			0x03
+#define BM_CTL_DIS			0x00
+#define BM_CTL_BYTE_ORD_LE		0x00
+#define BM_CTL_BYTE_ORD_BE		0x04
 /* cs5535 specific ac97 codec register defines */
 #define CMD_MASK			0xFF00FFFF
 #define CMD_NEW				0x00010000
