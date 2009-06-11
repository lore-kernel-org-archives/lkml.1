Return-Path: <linux-kernel-owner+w=401wt.eu-S1759856AbZFKQa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759856AbZFKQa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 12:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbZFKQaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 12:30:18 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:63425 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbZFKQaQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 12:30:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=J498uqMsgdtfk56FfnSm+z+hJAAS/kO79Oqg6jWjLloKuP/cZJu7qm0LPaWMl/IXy7
         J5zGlUdCOvyu/yNqb7jmW14QH9vAdqvdqowey2yigVXHDuI4PLfiYICFpwiUYLY+2hAR
         hLb9ZIfiMth4rw44En3Y71wF7EG60Qv+dtg/s=
MIME-Version: 1.0
Date: Thu, 11 Jun 2009 18:30:17 +0200
Message-ID: <2aac3c260906110930k49d70eb9o9922795a5bfdadf8@mail.gmail.com>
Subject: [PATCH] Possible memory leak in arch/cris/arch-v32/drivers/cryptocop.c
From: Giangiacomo Mariotti <giangiacomo.mariotti@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ee8e71f0ae1356b324906efc8e858b29025c60ef Mon Sep 17 00:00:00 2001
From: Giangiacomo Mariotti <giangiacomo.mariotti@gmail.com>
Date: Thu, 11 Jun 2009 18:13:52 +0200
Subject: [PATCH] Possible mem leak

---
 arch/cris/arch-v32/drivers/cryptocop.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/cris/arch-v32/drivers/cryptocop.c
b/arch/cris/arch-v32/drivers/cryptocop.c
index 67c61ea..fd529a0 100644
--- a/arch/cris/arch-v32/drivers/cryptocop.c
+++ b/arch/cris/arch-v32/drivers/cryptocop.c
@@ -1395,7 +1395,7 @@ static int create_md5_pad(int alloc_flag,
unsigned long long hashed_length, char
 	if (padlen < MD5_MIN_PAD_LENGTH) padlen += MD5_BLOCK_LENGTH;

 	p = kmalloc(padlen, alloc_flag);
-	if (!pad) return -ENOMEM;
+	if (!p) return -ENOMEM;

 	*p = 0x80;
 	memset(p+1, 0, padlen - 1);
@@ -1427,7 +1427,7 @@ static int create_sha1_pad(int alloc_flag,
unsigned long long hashed_length, cha
 	if (padlen < SHA1_MIN_PAD_LENGTH) padlen += SHA1_BLOCK_LENGTH;

 	p = kmalloc(padlen, alloc_flag);
-	if (!pad) return -ENOMEM;
+	if (!p) return -ENOMEM;

 	*p = 0x80;
 	memset(p+1, 0, padlen - 1);
--

-- 
You highest men whom my eyes have seen, this is my doubt about you and
my secret laughter: I guess that you would call my overman—devil!
What is great is so alien to your souls that the overman would be
terrifying to you in his goodness ...
