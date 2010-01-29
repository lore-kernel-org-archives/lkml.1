Return-Path: <linux-kernel-owner+w=401wt.eu-S932354Ab0A2KDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab0A2KDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 05:03:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756849Ab0A2KDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 05:03:23 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:24328 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884Ab0A2KDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 05:03:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=PiflraFM5WPXlGIuPPg7zGdpWRZ0sOFHGIB3C77BPqSdxqADMxP2Ig1bQQMCmkGOT4
         yRrUQylH2btX7yasQnidiFTwwE4crWn16eh4mCtKZVM7YMkAWfBY6GusmT/00zoatO8u
         pdjYIVPp1i3oIdWVIioJQgmRqqADAw2qqPrxQ=
Message-ID: <4B62B3C6.5090903@gmail.com>
Date: Fri, 29 Jan 2010 11:09:10 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] lpfc: Positive error return into negative
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the comment on top of lpfc_sli_hbq_setup() and of its caller which
transmits this error, lpfc_sli_hba_setup(), it is stated that the
function should return a negative error code.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 589549b..a960736 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -3709,7 +3709,7 @@ lpfc_sli_hbq_setup(struct lpfc_hba *phba)
 
 			phba->link_state = LPFC_HBA_ERROR;
 			mempool_free(pmb, phba->mbox_mem_pool);
-			return ENXIO;
+			return -ENXIO;
 		}
 	}
 	phba->hbq_count = hbq_count;
