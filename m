Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbZGEJBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbZGEJBd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 05:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbZGEJB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 05:01:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:65205 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbZGEJBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 05:01:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TVjqVD8XDF1cKgV4lhyx07Am95jAam5GkrOsN9f5dfUW+PTczU/AlfDdnHTkCLTzYt
         FbYnX4TB8oR+wgQahX1wg/nVu/cpPa4Z1ckILfmnVopm8bJwrwdWMRuSJuCWy4MQS5BV
         dF73Itnj78VhVQ2RknRinEv2NYwV+d1woU+Kc=
Subject: [PATCH v3]mempool.c : clean up type-casting twice
From: "Figo.zhang" <figo1802@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1246766651.15308.13.camel@myhost>
References: <1246762120.15308.3.camel@myhost>
	 <1246766651.15308.13.camel@myhost>
Content-Type: text/plain
Date: Sun, 05 Jul 2009 17:01:24 +0800
Message-Id: <1246784484.4358.3.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clean up type-casting twice. "size_t" typedef as "unsigned long" in 64-bit system,
and "unsigned int" in 32-bit system.

in v3, remove the space to casts.

Signed-off-by: Figo.zhang <figo1802@gmail.com>
---    
mm/mempool.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mempool.c b/mm/mempool.c
index a46eb1b..32e75d4 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -303,14 +303,14 @@ EXPORT_SYMBOL(mempool_free_slab);
  */
 void *mempool_kmalloc(gfp_t gfp_mask, void *pool_data)
 {
-	size_t size = (size_t)(long)pool_data;
+	size_t size = (size_t)pool_data;
 	return kmalloc(size, gfp_mask);
 }
 EXPORT_SYMBOL(mempool_kmalloc);
 
 void *mempool_kzalloc(gfp_t gfp_mask, void *pool_data)
 {
-	size_t size = (size_t) pool_data;
+	size_t size = (size_t)pool_data;
 	return kzalloc(size, gfp_mask);
 }
 EXPORT_SYMBOL(mempool_kzalloc);


