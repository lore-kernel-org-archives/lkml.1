Return-Path: <linux-kernel-owner+w=401wt.eu-S1754306AbYGZGY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbYGZGY6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 02:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbYGZGYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 02:24:49 -0400
Received: from nebensachen.de ([195.34.83.29]:37635 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbYGZGYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 02:24:48 -0400
X-Hashcash: 1:20:080726:alan@lxorguk.ukuu.org.uk::qliUUxfUu8KXmHc9:0000000000000000000000000000000000000Gcr/
X-Hashcash: 1:20:080726:jeff@garzik.org::JNgmu9xaUqW6mgxQ:001XAj
X-Hashcash: 1:20:080726:bzolnier@gmail.com::yfgEqQJnLj4dsB3O:00000000000000000000000000000000000000000000dgz
X-Hashcash: 1:20:080726:james.bottomley@hansenpartnership.com::Z6ZrQmADEkGkIgFW:0000000000000000000000005BbE
X-Hashcash: 1:20:080726:pavel@ucw.cz::GWhjoI+xO1LEKoTt:0000008/Q
X-Hashcash: 1:20:080726:linux-ide@vger.kernel.org::BAWub9HQ2fungaY9:0000000000000000000000000000000000000jBz
X-Hashcash: 1:20:080726:linux-kernel@vger.kernel.org::8xJv7bpwJeyxU9kp:0000000000000000000000000000000000y7s
From: Elias Oltmanns <eo@nebensachen.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] Introduce ata_id_has_unload()
In-Reply-To: <87prp1kvyy.fsf@denkblock.local>
Message-ID: <20080726062142.29070.87751.stgit@denkblock.local>
References: <87prp1kvyy.fsf@denkblock.local>
User-Agent: StGIT/0.14.2
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Date: Sat, 26 Jul 2008 08:24:35 +0200
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function to check an ATA device's id for head unload support as
specified in ATA-7.

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---

 include/linux/ata.h |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/linux/ata.h b/include/linux/ata.h
index cf4ef6d..c92ac10 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -530,6 +530,21 @@ static inline bool ata_id_has_dipm(const u16 *id)
 }
 
 
+static inline int ata_id_has_unload(const u16 *id)
+{
+	/*
+	 * ATA-7 specifies two places to indicate unload feature support.
+	 * Since I don't really understand the difference, I'll just check
+	 * both and only return zero if none of them indicates otherwise.
+	 */
+	if ((id[ATA_ID_CFSSE] & 0xC000) == 0x4000
+	    && id[ATA_ID_CFSSE] & (1 << 13))
+		return id[ATA_ID_CFSSE] & (1 << 13);
+	if ((id[ATA_ID_CSF_DEFAULT] & 0xC000) == 0x4000)
+		return id[ATA_ID_CSF_DEFAULT] & (1 << 13);
+	return 0;
+}
+
 static inline int ata_id_has_fua(const u16 *id)
 {
 	if ((id[ATA_ID_CFSSE] & 0xC000) != 0x4000)


