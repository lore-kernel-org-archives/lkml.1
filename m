Return-Path: <linux-kernel-owner+w=401wt.eu-S934713AbZKYOLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934713AbZKYOLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 09:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbZKYOLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 09:11:21 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:46801 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbZKYOLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 09:11:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=VmKlurluYGSEqtLSi77nuAjjl4gmAx5/yHAc/Zxe47gVxvsHchl1E59AAuWfN3JYrZ
         KxKdZqZC74IHdFulf1SHmGg1n7U8MIA1i+P/HX47BrKeot7+VLWvH0Lk5Zx79k1RPqn/
         ogEXo1bufhduSldbLtRTmWoo+jcOWNyDsxB4U=
Date: Wed, 25 Nov 2009 22:15:42 +0800
From: "Liuweni" <qingshenlwy@gmail.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "strongzgy" <strongzgy@gmail.com>, "xgr178" <xgr178@163.com>,
       "Liu Hui" <onlyflyer@gmail.com>
Subject: [PATCH 3/3]fs/inode: iunique() Optimize Performance
Message-ID: <200911252215376876159@gmail.com>
X-mailer: Foxmail 6, 15, 201, 22 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
Add the macro L1_CACHE_SHIFT into the arch/h8300/include/asm/cache.h
In this architecture, missing L1_CACHE_SHIFT, The iunique() optimize 
performance will not work correctly .
---
Signed-off-by: Liuwenyi<qingshenlwy@gmail.com>
Cc: linux-kernel@vger.kernel.org
---
diff --git a/arch/h8300/include/asm/cache.h b/arch/h8300/include/asm/cache.h
index c635028..0a73cd5 100644
--- a/arch/h8300/include/asm/cache.h
+++ b/arch/h8300/include/asm/cache.h
@@ -3,6 +3,7 @@
 
 /* bytes per L1 cache line */
 #define        L1_CACHE_BYTES  4
+#define        L1_CACHE_SHIFT  2
 
 /* m68k-elf-gcc  2.95.2 doesn't like these */
 

 				
--------------

Best Regards,
Liuweni
2009-11-25

