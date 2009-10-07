Return-Path: <linux-kernel-owner+w=401wt.eu-S1754805AbZJGGMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbZJGGMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 02:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbZJGGMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 02:12:34 -0400
Received: from mail.perches.com ([173.55.12.10]:1976 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbZJGGMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 02:12:34 -0400
Subject: [PATCH 9/8] efi.h: Use %pUl to print UUIDs
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1254890742-28245-1-git-send-email-joe@perches.com>
References: <1254890742-28245-1-git-send-email-joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Oct 2009 23:11:56 -0700
Message-Id: <1254895916.2134.328.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shrinks vmlinux

without:
$ size vmlinux
   text    data     bss     dec     hex filename
6975863  679652 1359668 9015183  898f8f vmlinux

with:
$ size vmlinux
   text    data     bss     dec     hex filename
6975639 679652 1359668 9014959 898eaf vmlinux

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/include/linux/efi.h b/include/linux/efi.h
index ce4581f..fb737bc 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -280,11 +280,7 @@ efi_guidcmp (efi_guid_t left, efi_guid_t right)
 static inline char *
 efi_guid_unparse(efi_guid_t *guid, char *out)
 {
-	sprintf(out, "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x",
-		guid->b[3], guid->b[2], guid->b[1], guid->b[0],
-		guid->b[5], guid->b[4], guid->b[7], guid->b[6],
-		guid->b[8], guid->b[9], guid->b[10], guid->b[11],
-		guid->b[12], guid->b[13], guid->b[14], guid->b[15]);
+	sprintf(out, "%pUl", guid->b);
         return out;
 }
 



