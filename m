Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbZBOXVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbZBOXVP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 18:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbZBOXU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 18:20:58 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:55520 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbZBOXU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 18:20:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=gGeBNhAnux0SDHL0Y/BepPC/JDd+y+R1Hu/WE1rTSXacwg/aDrHYN/XkdCarhhHTSL
         yHLsFSqxYPR56Ho5Iau6ElXOs6y9Npwyte6KOMPEi4Fw1PpD1Eugggqvlthat4IRwSQe
         mKsBA6PnRN6Rm/yxnl69hJsg8sSGJLWeF2uNM=
Message-ID: <4998A35A.5020708@gmail.com>
Date: Mon, 16 Feb 2009 00:20:58 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] FRV: __pte_to_swp_entry doesn't expand correctly
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macro doesn't expand correctly when its parameter isn't 'pte'.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/include/asm-frv/pgtable.h b/include/asm-frv/pgtable.h
index 83c51ab..e16fdb1 100644
--- a/include/asm-frv/pgtable.h
+++ b/include/asm-frv/pgtable.h
@@ -478,7 +478,7 @@ static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 #define __swp_type(x)			(((x).val >> 2) & 0x1f)
 #define __swp_offset(x)			((x).val >> 8)
 #define __swp_entry(type, offset)	((swp_entry_t) { ((type) << 2) | ((offset) << 8) })
-#define __pte_to_swp_entry(pte)		((swp_entry_t) { (pte).pte })
+#define __pte_to_swp_entry(_pte)	((swp_entry_t) { (_pte).pte })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
 static inline int pte_file(pte_t pte)
