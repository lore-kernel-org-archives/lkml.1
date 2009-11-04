Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbZKDRcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbZKDRcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:32:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295AbZKDRcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:32:46 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:41096 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755792AbZKDRco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:32:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=PuNztqoAA6HYDbgWv+MKWtUopis3thNdMU+byvui4VbsB+li3hsTKBxCHyWIaiBUMR
         a5jzghhDmmdpYG6pFyt06GfuufGG4DvwJyQU0VQdj3kgFYYgRpmU7etisWMFNzSSP9FK
         dCRufHqtb9sYftUgqqpg2J/WZBqeJZ7EgubWw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:32:24 +0100
Message-Id: <20091104173224.28463.49296.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 04/41] rt2800pci: fix crypto in TX frame
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800pci: fix crypto in TX frame

Based on rt2800usb patch from Benoit PAPILLAULT
(commit 17616310836ad2cc45a64576ef0e1520b0dcc81b).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/net/wireless/rt2x00/rt2800pci.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -2195,7 +2195,7 @@ static void rt2800pci_write_tx_desc(stru
 	rt2x00_set_field32(&word, TXWI_W1_BW_WIN_SIZE, txdesc->ba_size);
 	rt2x00_set_field32(&word, TXWI_W1_WIRELESS_CLI_ID,
 			   test_bit(ENTRY_TXD_ENCRYPT, &txdesc->flags) ?
-			       (skbdesc->entry->entry_idx + 1) : 0xff);
+			   txdesc->key_idx : 0xff);
 	rt2x00_set_field32(&word, TXWI_W1_MPDU_TOTAL_BYTE_COUNT,
 			   skb->len - txdesc->l2pad);
 	rt2x00_set_field32(&word, TXWI_W1_PACKETID,
