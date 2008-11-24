Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbYKXSJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbYKXSJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 13:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbYKXSIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 13:08:55 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:62070 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621AbYKXSIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 13:08:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=sECLb1vO046qDOKDGQmPBYBpig2cRm+ZRF3xGVmZ0yO6/gKb1FxHZ++/PjegC+h5xC
         IErLlouKe323D2bBL9D/J4cwBYPcL5cSPTslHmoDN+3PDRL8N8G2gACe4aqjkqCIrTFo
         CmcJAUc4sdy/NY/0u8LqpkyW9EYsbkE3k9VA4=
Subject: [PATCH] i2c: misannotation in i2c-pmcmsp.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 24 Nov 2008 10:08:49 -0800
Message-Id: <1227550129.5511.4.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tmp is used as host-endian and is loaded from a be64, fix the
cast and the endian accessor used.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/i2c/busses/i2c-pmcmsp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-pmcmsp.c b/drivers/i2c/busses/i2c-pmcmsp.c
index dcf2045..0bdb2d7 100644
--- a/drivers/i2c/busses/i2c-pmcmsp.c
+++ b/drivers/i2c/busses/i2c-pmcmsp.c
@@ -486,7 +486,7 @@ static enum pmcmsptwi_xfer_result pmcmsptwi_xfer_cmd(
 
 	if (cmd->type == MSP_TWI_CMD_WRITE ||
 	    cmd->type == MSP_TWI_CMD_WRITE_READ) {
-		__be64 tmp = cpu_to_be64p((u64 *)cmd->write_data);
+		u64 tmp = be64_to_cpup((__be64 *)cmd->write_data);
 		tmp >>= (MSP_MAX_BYTES_PER_RW - cmd->write_len) * 8;
 		dev_dbg(&pmcmsptwi_adapter.dev, "Writing 0x%016llx\n", tmp);
 		pmcmsptwi_writel(tmp & 0x00000000ffffffffLL,
-- 
1.6.0.4.1013.gc6a01



