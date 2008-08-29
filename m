Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbYH2VRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbYH2VRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 17:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756823AbYH2VR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 17:17:27 -0400
Received: from nebensachen.de ([195.34.83.29]:51620 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756123AbYH2VRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 17:17:25 -0400
X-Hashcash: 1:20:080829:alan@lxorguk.ukuu.org.uk::vDNnRG9KvPrjToMV:00000000000000000000000000000000000001Sbb
X-Hashcash: 1:20:080829:akpm@linux-foundation.org::6p8/DF6H1YTmbQs2:00000000000000000000000000000000000079XS
X-Hashcash: 1:20:080829:bzolnier@gmail.com::pVVUI/a0Q62iwfA8:00000000000000000000000000000000000000000000OyS
X-Hashcash: 1:20:080829:jeff@garzik.org::EleGek5pFBQ0q6Z4:000KUF
X-Hashcash: 1:20:080829:randy.dunlap@oracle.com::34qa3aagIfy7D2Hb:000000000000000000000000000000000000001a59
X-Hashcash: 1:20:080829:htejun@gmail.com::Lv4nDh6837SxIl/p:08UyJ
X-Hashcash: 1:20:080829:linux-ide@vger.kernel.org::E+jL3i1dE4y4RI7r:0000000000000000000000000000000000001WR5
X-Hashcash: 1:20:080829:linux-kernel@vger.kernel.org::hYEExnyUps4bncl6:0000000000000000000000000000000003ITU
From: Elias Oltmanns <eo@nebensachen.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Tejun Heo <htejun@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] Introduce ata_id_has_unload()
In-Reply-To: <87wshzplvk.fsf@denkblock.local>
Message-ID: <20080829211345.4355.63012.stgit@denkblock.local>
References: <87wshzplvk.fsf@denkblock.local>
User-Agent: StGIT/0.14.2
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Date: Fri, 29 Aug 2008 23:16:47 +0200
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function to check an ATA device's id for head unload support as
specified in ATA-7.

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---

 include/linux/ata.h |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/include/linux/ata.h b/include/linux/ata.h
index 80364b6..d9a94bd 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -707,6 +707,23 @@ static inline int ata_id_has_dword_io(const u16 *id)
 	return 0;
 }
 
+static inline int ata_id_has_unload(const u16 *id)
+{
+	/*
+	 * ATA-7 specifies two places to indicate unload feature
+	 * support. Since I don't really understand the difference,
+	 * I'll just check both and only return zero if none of them
+	 * indicates otherwise.
+	 */
+	if (ata_id_major_version(id) >= 7
+	    && (((id[ATA_ID_CFSSE] & 0xC000) == 0x4000
+		 && id[ATA_ID_CFSSE] & (1 << 13))
+		|| ((id[ATA_ID_CSF_DEFAULT] & 0xC000) == 0x4000
+		    && (id[ATA_ID_CSF_DEFAULT] & (1 << 13)))))
+		return 1;
+	return 0;
+}
+
 static inline int ata_id_current_chs_valid(const u16 *id)
 {
 	/* For ATA-1 devices, if the INITIALIZE DEVICE PARAMETERS command


