Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbZLWBRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbZLWBRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 20:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbZLWBRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 20:17:21 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:37002 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbZLWBRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 20:17:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=PvFF9UJ8dhNUEGcZvRNOUMnQjPnbVpN0DivF5czuZZP4qsKuAaWyw9z+dXxC3V2M2l
         vrlSx4XlRdJqUSYwvH++yQOZQMiPz2XPgEczezeHy21VOwfdxfnN9hMQ1lI1vO2obgGj
         QjUCEIcOJTF+4PFzxc9Jd8vSjtlkIBv0xtZpw=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       sam@ravnborg.org, dhowells@redhat.com,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] BUG(): CONFIG_BUG=n version of BUG() should be unreachable()
Date: Wed, 23 Dec 2009 04:17:12 +0300
Message-Id: <1261531032-15225-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.6.rc4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previouss definition of BUG() as 'do {} while(0)' produced compilation
warnings when BUG() was used in default branch of switch() statement
(control reaches end of non-void function).

Example:
unsigned long function()
{
	switch() {
	case 1:
		return 1;
	case 2:
		return 2;
	default:
		BUG();
}

Using unreachable() fixes the problem.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 18c435d..1106439 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -89,7 +89,7 @@ extern void warn_slowpath_null(const char *file, const int line);
 
 #else /* !CONFIG_BUG */
 #ifndef HAVE_ARCH_BUG
-#define BUG() do {} while(0)
+#define BUG() unreachable() 
 #endif
 
 #ifndef HAVE_ARCH_BUG_ON
-- 
1.6.6.rc4

