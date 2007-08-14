Return-Path: <linux-kernel-owner+w=401wt.eu-S1763294AbXHNVgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763294AbXHNVgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756758AbXHNVXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:23:31 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38453 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756693AbXHNVX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:23:28 -0400
Date: Tue, 14 Aug 2007 23:23:19 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [-mm patch] unexport ide_tune_dma
Message-ID: <20070814212319.GN18945@stusta.de>
References: <20070809224254.11f42716.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070809224254.11f42716.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 10:42:54PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.23-rc1-mm2:
>...
> +ide-ide-remove-ide-dma-check.patch
> 
>  IDE tree updates
>...

static code mustn't be exported.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
8cc9125428c1a2c547e76cd5f37b109b1991eb68 
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index 5a774d8..10c6739 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -778,8 +778,6 @@ static int ide_tune_dma(ide_drive_t *drive)
 	return 1;
 }
 
-EXPORT_SYMBOL_GPL(ide_tune_dma);
-
 static int ide_dma_check(ide_drive_t *drive)
 {
 	int vdma = (drive->hwif->host_flags & IDE_HFLAG_VDMA)? 1 : 0;

