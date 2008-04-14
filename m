Return-Path: <linux-kernel-owner+w=401wt.eu-S1763236AbYDNQjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763236AbYDNQjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 12:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762898AbYDNQil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 12:38:41 -0400
Received: from rn-out-0910.google.com ([64.233.170.185]:30603 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762877AbYDNQik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 12:38:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VCBV0JnuFo2OyVQY5QUYvYrcNgaOHXLAoEpC7DdbV/e+ydJle8/rW29aOm2bdVC5Eq1plMVyJxQ4yla6wlynpGeZlx04bEMxZs8Q1zP98fOmwD8730jufU22bQWWVRBfhvirogmbh1RaeKT3ts+n99xJsQPI9Ar7Pc6u1G5L1to=
Subject: [PATCH 05/10] mmc: Use get/put_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 09:37:55 -0700
Message-Id: <1208191075.5721.27.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/mmc/host/mmc_spi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 365024b..3550858 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -340,7 +340,7 @@ checkstatus:
 
 	/* SPI R3, R4, or R7 == R1 + 4 bytes */
 	case MMC_RSP_SPI_R3:
-		cmd->resp[1] = be32_to_cpu(get_unaligned((u32 *)cp));
+		cmd->resp[1] = get_unaligned_be32(cp);
 		break;
 
 	/* SPI R1 == just one status byte */
-- 
1.5.5.144.g3e42


