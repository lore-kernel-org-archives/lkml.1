Return-Path: <linux-kernel-owner+w=401wt.eu-S1756063AbYK2LRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbYK2LRm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 06:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbYK2LRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 06:17:34 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:18984 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbYK2LRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 06:17:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=upgiz1dfyDvElKLBkiacAKwlsMnuhaRyXZB9wMu0BTWeftXNeX0f2WiJwaHwSg1IVa
         fz5abSn/c4mWvoAspLr6KgIVLSFFl+2Rj6cyijMcRN2Qm1cHkp0mGBjwgjgxMao8N7XM
         xnKhbgSgCzB9YYvKZwgJ9goUXm+Utt3rWWz8c=
Message-ID: <493124C7.9030704@gmail.com>
Date: Sat, 29 Nov 2008 06:17:27 -0500
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: paulus@samba.org
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [POWERPC] smu_sat_get_sdb_partition() - unsigned len cannot
 be negative
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2c_smbus_read_word_data() returns a s32, which may be negative
but unsigned len cannot be negative.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
for i2c_smbus_read_word_data(), see
vi drivers/i2c/i2c-core.c +1663

diff --git a/drivers/macintosh/windfarm_smu_sat.c b/drivers/macintosh/windfarm_smu_sat.c
index 7f2be4b..7847e98 100644
--- a/drivers/macintosh/windfarm_smu_sat.c
+++ b/drivers/macintosh/windfarm_smu_sat.c
@@ -87,11 +87,12 @@ struct smu_sdbp_header *smu_sat_get_sdb_partition(unsigned int sat_id, int id,
 		return NULL;
 	}
 
-	len = i2c_smbus_read_word_data(&sat->i2c, 9);
-	if (len < 0) {
+	err = i2c_smbus_read_word_data(&sat->i2c, 9);
+	if (err < 0) {
 		printk(KERN_ERR "smu_sat_get_sdb_part rd len error\n");
 		return NULL;
 	}
+	len = err;
 	if (len == 0) {
 		printk(KERN_ERR "smu_sat_get_sdb_part no partition %x\n", id);
 		return NULL;


