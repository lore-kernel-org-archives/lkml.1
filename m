Return-Path: <linux-kernel-owner+w=401wt.eu-S1766782AbXEBRBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766782AbXEBRBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766786AbXEBRBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:01:04 -0400
Received: from smtp-out.google.com ([216.239.45.13]:5371 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766782AbXEBRBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:01:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:message-id:
	mime-version:content-type;
	b=fvvdbi+Pnzh/PZFRa/waVwoFuoVN9Bti4YwJfG2ePn1G3KmYbYBFN2Tjts5dObugX
	1roi1P44xiOct2YhnInIA==
Date: Wed, 2 May 2007 10:00:08 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Adam Belay <ambx1@neo.rr.com>, Jaroslav Kysela <perex@suse.cz>,
       linux-kernel@vger.kernel.org
Subject: [patch] wavefront: only declare isapnp on CONFIG_PNP
Message-ID: <Pine.LNX.4.64.0705020042520.22968@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

isapnp[] is only used for CONFIG_PNP.  If this configuration option is
not set, do not declare the array.

Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 sound/isa/wavefront/wavefront.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/isa/wavefront/wavefront.c b/sound/isa/wavefront/wavefront.c
--- a/sound/isa/wavefront/wavefront.c
+++ b/sound/isa/wavefront/wavefront.c
@@ -40,7 +40,9 @@ MODULE_SUPPORTED_DEVICE("{{Turtle Beach,Maui/Tropez/Tropez+}}");
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	    /* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	    /* ID for this card */
 static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	    /* Enable this card */
+#ifdef CONFIG_PNP
 static int isapnp[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1};
+#endif
 static long cs4232_pcm_port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* PnP setup */
 static int cs4232_pcm_irq[SNDRV_CARDS] = SNDRV_DEFAULT_IRQ; /* 5,7,9,11,12,15 */
 static long cs4232_mpu_port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT; /* PnP setup */
