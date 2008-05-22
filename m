Return-Path: <linux-kernel-owner+w=401wt.eu-S1765249AbYEVWpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765249AbYEVWpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756830AbYEVWpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:45:14 -0400
Received: from rn-out-0910.google.com ([64.233.170.185]:39533 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbYEVWpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:45:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XqPGyGE3ocL+bFRO+ZVabjRPjN5fmgLeazunUKjel5H7YEO8rpuGyo0FJxyw4X9D7tgVUhF6VOjKqia1e43RNtT5V8tzTUFnMWpiarNZSXck2pEkZ7rHr/Buby5Iit2Bg2DbmKJYSxBsMmG/ag4zkDArDQr1lMmMgIH68lBrBU4=
Subject: [PATCH 3/5] isdn: fix integer as NULL pointer warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 22 May 2008 15:45:07 -0700
Message-Id: <1211496307.6888.10.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/isdn/hysdn/hycapi.c:465:42: warning: Using plain integer as NULL pointer
drivers/isdn/hysdn/hycapi.c:467:44: warning: Using plain integer as NULL pointer
drivers/isdn/hysdn/hycapi.c:469:42: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/isdn/hysdn/hycapi.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/hysdn/hycapi.c b/drivers/isdn/hysdn/hycapi.c
index d3999a8..53f6ad1 100644
--- a/drivers/isdn/hysdn/hycapi.c
+++ b/drivers/isdn/hysdn/hycapi.c
@@ -462,11 +462,11 @@ static int hycapi_read_proc(char *page, char **start, off_t off,
 		default: s = "???"; break;
 	}
 	len += sprintf(page+len, "%-16s %s\n", "type", s);
-	if ((s = cinfo->version[VER_DRIVER]) != 0)
+	if ((s = cinfo->version[VER_DRIVER]) != NULL)
 		len += sprintf(page+len, "%-16s %s\n", "ver_driver", s);
-	if ((s = cinfo->version[VER_CARDTYPE]) != 0)
+	if ((s = cinfo->version[VER_CARDTYPE]) != NULL)
 		len += sprintf(page+len, "%-16s %s\n", "ver_cardtype", s);
-	if ((s = cinfo->version[VER_SERIAL]) != 0)
+	if ((s = cinfo->version[VER_SERIAL]) != NULL)
 		len += sprintf(page+len, "%-16s %s\n", "ver_serial", s);
     
 	len += sprintf(page+len, "%-16s %s\n", "cardname", cinfo->cardname);
-- 
1.5.5.1.579.g4e43


