Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059Ab0ARRPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab0ARRPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932105Ab0ARRPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:15:36 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:63985 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576Ab0ARRPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:15:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=SAsJAvfn3wnCLWgQJ/ODrd63hjzHq2RNrrRVZahRtdJJoQrAxnM7L1BTRKj35kHayJ
         Qffv5QPVZuxGASkNHQW7IFH7FjzNDodstYjoq18qIwgxI8byFl3rZqAvWboXLnBONxYc
         JU63NctRc/exqKHpGc5I67Uya1cCsxMu7vddA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:14:20 +0100
Message-Id: <20100118171420.14623.85263.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 04/64] pata_amd: remove bogus code from timing_setup()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_amd: remove bogus code from timing_setup()

DMA modes don't have 8-bit timings.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_amd.c |    5 -----
 1 file changed, 5 deletions(-)

Index: b/drivers/ata/pata_amd.c
===================================================================
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -65,11 +65,6 @@ static void timing_setup(struct ata_port
 	}
 
 	if (peer) {
-		/* This may be over conservative */
-		if (peer->dma_mode) {
-			ata_timing_compute(peer, peer->dma_mode, &apeer, T, UT);
-			ata_timing_merge(&apeer, &at, &at, ATA_TIMING_8BIT);
-		}
 		ata_timing_compute(peer, peer->pio_mode, &apeer, T, UT);
 		ata_timing_merge(&apeer, &at, &at, ATA_TIMING_8BIT);
 	}
