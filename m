Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbZG2MOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbZG2MOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 08:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbZG2MOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 08:14:43 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:45496 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499AbZG2MOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 08:14:41 -0400
From: Nicolas Palix <npalix@diku.dk>
To: gregkh@suse.de, hjanssen@microsoft.com, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] Staging: hv: Fix warning by casting a (const void *) to (void *)
Date: Wed, 29 Jul 2009 14:10:28 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907291410.29355.npalix@diku.dk>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix compilation warning by casting the const void *Buffer
variable into a void *.

Signed-off-by: Nicolas Palix <npalix@diku.dk>
---
 drivers/staging/hv/Channel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/Channel.c b/drivers/staging/hv/Channel.c
index 68f3442..854fa30 100644
--- a/drivers/staging/hv/Channel.c
+++ b/drivers/staging/hv/Channel.c
@@ -787,7 +787,7 @@ VmbusChannelSendPacket(
 	bufferList[0].Data = &desc;
 	bufferList[0].Length = sizeof(VMPACKET_DESCRIPTOR);
 
-	bufferList[1].Data = Buffer;
+	bufferList[1].Data = (void *)Buffer;
 	bufferList[1].Length = BufferLen;
 
 	bufferList[2].Data = &alignedData;
-- 
1.6.0.4


-- 
Nicolas Palix
