Return-Path: <linux-kernel-owner+w=401wt.eu-S1763294AbZGAAp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763294AbZGAAp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761096AbZGAAdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:33:16 -0400
Received: from kroah.org ([198.145.64.141]:59909 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761102AbZGAAdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:33:15 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:15:53 2009
Message-Id: <20090701001553.621173501@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:14:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andrew Vasquez <andrew.vasquez@qlogic.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 30/35] qla2xxx: Correct (again) overflow during dump-processing on large-memory ISP23xx parts.
References: <20090701001356.007288418@mini.kroah.org>
Content-Disposition: inline; filename=qla2xxx-correct-overflow-during-dump-processing-on-large-memory-isp23xx-parts.patch
In-Reply-To: <20090701002825.GA6518@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit e18e963b7e533149676b5d387d0a56160df9f111 upstream.

Commit 7b867cf76fbcc8d77867cbec6f509f71dce8a98f ([SCSI] qla2xxx:
Refactor qla data structures) inadvertently reverted
e792121ec85672c1fa48f79d13986a3f4f56c590 ([SCSI] qla2xxx: Correct
overflow during dump-processing on large-memory ISP23xx parts.).

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/qla2xxx/qla_dbg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -218,7 +218,7 @@ qla24xx_soft_reset(struct qla_hw_data *h
 
 static int
 qla2xxx_dump_ram(struct qla_hw_data *ha, uint32_t addr, uint16_t *ram,
-    uint16_t ram_words, void **nxt)
+    uint32_t ram_words, void **nxt)
 {
 	int rval;
 	uint32_t cnt, stat, timer, words, idx;


