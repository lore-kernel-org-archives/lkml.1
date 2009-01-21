Return-Path: <linux-kernel-owner+w=401wt.eu-S1763548AbZAUPAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763548AbZAUPAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 10:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbZAUO76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 09:59:58 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:56948 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbZAUO75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 09:59:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=YnWQVeYiduLc6+Yye/K06j8KW30eydDWUfnFpd50DQZzx3YdO2uwkKROPJs/NUuK+/
         MFiod4RSTZ/b3HkkZSlkx33ei9pE0uA4DMv+v3farJaSmhjjPtVH/716jOe/MpanhosN
         Ybe7WAeQmLuEpRb84CpsWqmr5172uy25MXA+8=
Message-ID: <4977386C.5070703@gmail.com>
Date: Wed, 21 Jan 2009 15:59:56 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: rth@twiddle.net
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] alpha: fix macros
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When this macros isn't called with 'fixup', e.g. with foo
this will incorectly expand to foo->foo.bits.errreg

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/arch/alpha/include/asm/uaccess.h b/arch/alpha/include/asm/uaccess.h
index 22de3b4..163f305 100644
--- a/arch/alpha/include/asm/uaccess.h
+++ b/arch/alpha/include/asm/uaccess.h
@@ -498,13 +498,13 @@ struct exception_table_entry
 };
 
 /* Returns the new pc */
-#define fixup_exception(map_reg, fixup, pc)			\
+#define fixup_exception(map_reg, _fixup, pc)			\
 ({								\
-	if ((fixup)->fixup.bits.valreg != 31)			\
-		map_reg((fixup)->fixup.bits.valreg) = 0;	\
-	if ((fixup)->fixup.bits.errreg != 31)			\
-		map_reg((fixup)->fixup.bits.errreg) = -EFAULT;	\
-	(pc) + (fixup)->fixup.bits.nextinsn;			\
+	if ((_fixup)->fixup.bits.valreg != 31)			\
+		map_reg((_fixup)->fixup.bits.valreg) = 0;	\
+	if ((_fixup)->fixup.bits.errreg != 31)			\
+		map_reg((_fixup)->fixup.bits.errreg) = -EFAULT;	\
+	(pc) + (_fixup)->fixup.bits.nextinsn;			\
 })
 
 

