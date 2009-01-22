Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbZAVOIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbZAVOIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 09:08:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755135AbZAVOHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 09:07:54 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:35967 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097AbZAVOHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 09:07:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=IhVTmvHnuCZXh2hAlj463Kv7OzFZQz2eCW+a5NLcCXvw3OEM0ezwM0iDB71FiqEaEb
         WVp+bUiJxSiFS0wK8YwI+aDuliuMkDPbafGtl66Br2oC/CkZsAIakePqEkWwN+cx9IRV
         +DHI/e2K4MleU20YxldZ4HGCRQtpm0o1UH2+8=
Message-ID: <49787DB4.8080308@gmail.com>
Date: Thu, 22 Jan 2009 15:07:48 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] asm-generic: fix local_add_unless macro
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When this macro isn't called with 'a' this will 
result in a build failure.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/include/asm-generic/local.h b/include/asm-generic/local.h
index dbd6150..fc21844 100644
--- a/include/asm-generic/local.h
+++ b/include/asm-generic/local.h
@@ -42,7 +42,7 @@ typedef struct
 
 #define local_cmpxchg(l, o, n) atomic_long_cmpxchg((&(l)->a), (o), (n))
 #define local_xchg(l, n) atomic_long_xchg((&(l)->a), (n))
-#define local_add_unless(l, a, u) atomic_long_add_unless((&(l)->a), (a), (u))
+#define local_add_unless(l, _a, u) atomic_long_add_unless((&(l)->a), (_a), (u))
 #define local_inc_not_zero(l) atomic_long_inc_not_zero(&(l)->a)
 
 /* Non-atomic variants, ie. preemption disabled and won't be touched
