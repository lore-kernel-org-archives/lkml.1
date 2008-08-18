Return-Path: <linux-kernel-owner+w=401wt.eu-S1755097AbYHRQe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097AbYHRQe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbYHRQeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:34:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:3985 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbYHRQeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:34:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=D8j1kOoLkd5xMFr5cu8ZPcKyOptaiNWurC0mIiQD0r8T0Gp271jTuph6k6GBejgZjR
         Ncl7aeP+QzCwPm4gP5ttgXbHkiXNob3aKIe1Dvsp/w0vy8Tw484bOhIojiZ+nDybF/Fv
         TejmshjCw3is3p+pl7G5jtqnng8mTXT/E4RnY=
Message-ID: <48A9F8E9.8030303@gmail.com>
Date: Mon, 18 Aug 2008 18:34:17 -0400
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: paulus@samba.org, benh@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] POWERPC: duplicate test of MACIO_FLAG_SCCB_ON
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

untested, is it correct?

arch/powerpc/include/asm/pmac_feature.h:359:
#define MACIO_FLAG_SCCA_ON  0x00000001
#define MACIO_FLAG_SCCB_ON  0x00000002
---
duplicate test of MACIO_FLAG_SCCB_ON

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/arch/powerpc/platforms/powermac/feature.c b/arch/powerpc/platforms/powermac/feature.c
index 5169ecc..e6c0040 100644
--- a/arch/powerpc/platforms/powermac/feature.c
+++ b/arch/powerpc/platforms/powermac/feature.c
@@ -2677,7 +2677,7 @@ static void __init probe_one_macio(const char *name, const char *compat, int typ
 	macio_chips[i].of_node	= node;
 	macio_chips[i].type	= type;
 	macio_chips[i].base	= base;
-	macio_chips[i].flags	= MACIO_FLAG_SCCB_ON | MACIO_FLAG_SCCB_ON;
+	macio_chips[i].flags	= MACIO_FLAG_SCCA_ON | MACIO_FLAG_SCCB_ON;
 	macio_chips[i].name	= macio_names[type];
 	revp = of_get_property(node, "revision-id", NULL);
 	if (revp)
