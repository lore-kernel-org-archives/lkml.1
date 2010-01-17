Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121Ab0AQPLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab0AQPLS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 10:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791Ab0AQPLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 10:11:17 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:61355 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab0AQPLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 10:11:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=gZKg+JUC7lldimd4EXuyq4nq50M0p2pf0R0Zat5EOrr9vF1n1HotJThjxg5uIPYLi/
         8UzFpzwiQtnsO8YsMQMqJ//9hQkpF2MFXwubFfcnqryQOhuXLFQMUPqKgj6z7qjuzO5K
         iNTsP8uk8Y9RJflafZZMP+zlnlkNEqn/LDOxA=
Message-ID: <4B5329AD.9010100@gmail.com>
Date: Sun, 17 Jan 2010 16:15:57 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] lpfc: two branches the same in lpfc_decode_firmware_rev()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regardless of the flag state, the branches execute the same code

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 0ebcd9b..bf7bf62 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1843,12 +1843,7 @@ lpfc_decode_firmware_rev(struct lpfc_hba *phba, char *fwrevision, int flag)
 		c  = (rev & 0x0000ff00) >> 8;
 		b4 = (rev & 0x000000ff);
 
-		if (flag)
-			sprintf(fwrevision, "%d.%d%d%c%d ", b1,
-				b2, b3, c, b4);
-		else
-			sprintf(fwrevision, "%d.%d%d%c%d ", b1,
-				b2, b3, c, b4);
+		sprintf(fwrevision, "%d.%d%d%c%d", b1, b2, b3, c, b4);
 	}
 	return;
 }
