Return-Path: <linux-kernel-owner+w=401wt.eu-S1758200AbYG3FZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200AbYG3FZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 01:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbYG3FZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 01:25:25 -0400
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:21719 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752204AbYG3FZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 01:25:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Subject:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=ycKkBVeh0mb5GVbTXxK6TfJIINm7SSfY+Y0zTFa5zI41GKZgn7q0ZEs3/aAaEkqOItLZkFjw69BLtjUSaZ3BJXRoi7lMA4CfkBoYrywivAl/QeOa9ju7bHGitCuvOJnlTirIxnfqxejuIW8rbuUC0CUAs1/vqP1ZiVvrxOv5qW8=  ;
X-YMail-OSG: xON7eLkVM1ki3Ypydb0BnzjuQ62eUuZ3uzrGffNEWGqNria_engx7iAxw3BfMPTu3zvfSiWHHehtSOjF.cjyaQISIvnr6gNSP.16r9_12ZCRsuq8LvekuvLcfVpQ4XWRtIM-
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 29 Jul 2008 22:28:12 -0700
From: David Brownell <david-b@pacbell.net>
To: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
       akpm@linux-foundation.org
Subject: [PATCH 2.6.26-git] MTD_DEBUG always does compile-time typechecks
Cc: michael.hennerich@analog.com, linux-kernel@vger.kernel.org,
       cooloney@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080730052812.0D64C360E2D@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

The current style for debug messages is to ensure they're always
parsed by the compiler and then subjected to dead code removal.
That way builds won't break only when debug options get enabled,
which is common when they are stripped out early by CPP.

This patch makes CONFIG_MTD_DEBUG adopt that convention.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 include/linux/mtd/mtd.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/linux/mtd/mtd.h	2008-07-29 22:06:43.000000000 -0700
+++ b/include/linux/mtd/mtd.h	2008-07-29 22:19:21.000000000 -0700
@@ -272,7 +272,11 @@ static inline void mtd_erase_callback(st
 			printk(KERN_INFO args);		\
 	} while(0)
 #else /* CONFIG_MTD_DEBUG */
-#define DEBUG(n, args...) do { } while(0)
+#define DEBUG(n, args...)				\
+	do {						\
+		if (0)					\
+			printk(KERN_INFO args);		\
+	} while(0)
 
 #endif /* CONFIG_MTD_DEBUG */
 
