Return-Path: <linux-kernel-owner+w=401wt.eu-S1759411AbZKKVzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411AbZKKVzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759368AbZKKVzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:55:54 -0500
Received: from gv-out-0910.google.com ([216.239.58.186]:16719 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759299AbZKKVzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:55:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=IuhxTfrGTv9deZAhR9ARnuYBr/PV023Wb+w8fs0iKZWPUl12zeWwrhlMfe+lmcIo4J
         /2f0ie9aMdtTw86gwOBmB3/M978BCR0H04BSr7MX5B0QdPcaqOai822Zr7N9BMZbNekV
         OaSTVGl64k195L0IZmsU8dYmz9Edj6acI5l1g=
Message-ID: <4AFB35BD.2040100@gmail.com>
Date: Wed, 11 Nov 2009 23:07:57 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       spi-devel-general@lists.sourceforge.net
Subject: [PATCH] spi: Should error status be negative?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return a negative error value instead of a positive

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/spi/spi_stmp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

is this maybe required?

diff --git a/drivers/spi/spi_stmp.c b/drivers/spi/spi_stmp.c
index d871dc2..2552bb3 100644
--- a/drivers/spi/spi_stmp.c
+++ b/drivers/spi/spi_stmp.c
@@ -242,7 +242,7 @@ static int stmp_spi_txrx_dma(struct stmp_spi *ss, int cs,
 	wait_for_completion(&ss->done);
 
 	if (!busy_wait(readl(ss->regs + HW_SSP_CTRL0) & BM_SSP_CTRL0_RUN))
-		status = ETIMEDOUT;
+		status = -ETIMEDOUT;
 
 	if (!dma_buf)
 		dma_unmap_single(ss->master_dev, spi_buf_dma, len, dir);
