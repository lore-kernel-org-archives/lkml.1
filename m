Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbZELVcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbZELVcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 17:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbZELVb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 17:31:56 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:37488 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbZELVbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 17:31:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=DbciS8vRzOcvC8XLAMa5usLV7vD9meoGgyCDFZk2UQEGQFSv46Ggn8b8s7wLEz1PtT
         skhuLmgx537mmZrRYtlWm89yC+C/eGmMrhNapg3I6UwBpOJkdMBVS+XHlQB/vRq2mGqu
         QUYYMGQc/WjSTbY9pfTEsAEsV8aVXS/GCKchQ=
Message-ID: <4A09EAC9.2030104@gmail.com>
Date: Tue, 12 May 2009 23:31:53 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] asm-generic: fix local_add_unless macro
References: <49787DB4.8080308@gmail.com> <20090123154520.GB7774@Krystal>
In-Reply-To: <20090123154520.GB7774@Krystal>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------------------------------>8-------------8<---------------------------------
`local_add_unless(x, y, z)' will be expanded to `(&(x)->y, (y), (x))', but 
`&(x)->y' should be `&(x)->a'

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Was this patch lost? it's still not in current git.

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
