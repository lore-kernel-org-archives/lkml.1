Return-Path: <linux-kernel-owner+w=401wt.eu-S1753164AbZGEEEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbZGEEEU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 00:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbZGEEEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 00:04:13 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:35077 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbZGEEEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 00:04:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TN8NToJAssGjfzkdQ29sOg+4HujjrCJ6CSlKLLmsXpIX5aCGUQanPhVe9pZxQks1I9
         8mbyREHuJ1pXkixPzBbOgG08qMUHS2BcK4LVysvirnUprUrN5jTHpwAPyHxZbk108yu0
         ZwDQpjRkAyy6VTQwHSGqS+od8+/7Wdt3x+Kzc=
Subject: [PATCH v2]mempool.c : clean up type-casting twice
From: "Figo.zhang" <figo1802@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1246762120.15308.3.camel@myhost>
References: <1246762120.15308.3.camel@myhost>
Content-Type: text/plain
Date: Sun, 05 Jul 2009 12:04:11 +0800
Message-Id: <1246766651.15308.13.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clean up type-casting twice. "size_t" typedef as "unsigned long" in 64-bit system,
and "unsigned int" in 32-bit system.

Signed-off-by: Figo.zhang <figo1802@gmail.com>
---   
mm/mempool.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/mempool.c b/mm/mempool.c
index a46eb1b..bd22982 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -303,7 +303,7 @@ EXPORT_SYMBOL(mempool_free_slab);
  */
 void *mempool_kmalloc(gfp_t gfp_mask, void *pool_data)
 {
-	size_t size = (size_t)(long)pool_data;
+	size_t size = (size_t) pool_data;
 	return kmalloc(size, gfp_mask);
 }
 EXPORT_SYMBOL(mempool_kmalloc);


