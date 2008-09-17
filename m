Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbYIQQf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbYIQQf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbYIQQfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:35:11 -0400
Received: from nebensachen.de ([195.34.83.29]:54144 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731AbYIQQfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:35:09 -0400
X-Hashcash: 1:20:080917:bzolnier@gmail.com::p51S9nBi0KghXazT:00000000000000000000000000000000000000000002ftV
X-Hashcash: 1:20:080917:jeff@garzik.org::ik2dOEaTJIqviEnv:001yyK
X-Hashcash: 1:20:080917:randy.dunlap@oracle.com::NdXMbaLnelv7yTU2:000000000000000000000000000000000000005kSx
X-Hashcash: 1:20:080917:htejun@gmail.com::t8lYZFVimqbBTBcD:02crA
X-Hashcash: 1:20:080917:linux-ide@vger.kernel.org::G88D7eEWvdg02hFI:0000000000000000000000000000000000001K63
X-Hashcash: 1:20:080917:linux-kernel@vger.kernel.org::5aUAE6dovjWpEPKc:0000000000000000000000000000000000CV4
From: Elias Oltmanns <eo@nebensachen.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Tejun Heo <htejun@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4 v2] Introduce ata_id_has_unload()
In-Reply-To: <87d4j2n3dn.fsf@denkblock.local>
Message-ID: <20080917163144.9870.90985.stgit@denkblock.local>
References: <87d4j2n3dn.fsf@denkblock.local>
User-Agent: StGIT/0.14.2
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Date: Wed, 17 Sep 2008 18:34:53 +0200
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function to check an ATA device's id for head unload support as
specified in ATA-7.

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---

 include/linux/ata.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/ata.h b/include/linux/ata.h
index cea079c..c66a7d6 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -707,6 +707,15 @@ static inline int ata_id_has_dword_io(const u16 *id)
 	return 0;
 }
 
+static inline int ata_id_has_unload(const u16 *id)
+{
+	if (ata_id_major_version(id) >= 7 &&
+	    (id[ATA_ID_CFSSE] & 0xC000) == 0x4000 &&
+	    id[ATA_ID_CFSSE] & (1 << 13))
+		return 1;
+	return 0;
+}
+
 static inline int ata_id_current_chs_valid(const u16 *id)
 {
 	/* For ATA-1 devices, if the INITIALIZE DEVICE PARAMETERS command


