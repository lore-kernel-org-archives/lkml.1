Return-Path: <linux-kernel-owner+w=401wt.eu-S932703AbXHWXsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703AbXHWXsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 19:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758824AbXHWXsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 19:48:01 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:59147 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129AbXHWXsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 19:48:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:resent-from:resent-to:resent-date:resent-message-id:message-id:in-reply-to:references:from:date:subject:to:cc:mime-version:content-transfer-encoding:content-disposition;
        b=CB/TtPJ6tvvi9ec6OiXhkXnuZSzlt2detrPGBKI2B5HOz4HmyrQZ8sxf3p20orqQLwqcBEpZEnL2BicEGDrZT7tcy5VtHhEHwAvcLzCf2UtP7kNGCmo7sljInSBuEvUNsJy4HioUccYTEgH5RZLdeyWp2Q2iHtqsvRqBF/gpSqE=
Message-Id: <91dcfc2a1b0be436d04f9bc45bb6f8657a8d6ff4.1187912217.git.jesper.juhl@gmail.com>
In-Reply-To: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Fri, 24 Aug 2007 01:45:08 +0200
Subject: [PATCH 04/30] powerpc: Don't cast kmalloc return value in ibmebus.c
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Joachim Fenkes <fenkes@de.ibm.com>,
       Heiko J Schick <schickhj@de.ibm.com>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kmalloc() returns a void pointer so there is absolutely no need to
cast it in ibmebus_chomp().

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
 arch/powerpc/kernel/ibmebus.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/ibmebus.c b/arch/powerpc/kernel/ibmebus.c
index 9a8c9af..9514e66 100644
--- a/arch/powerpc/kernel/ibmebus.c
+++ b/arch/powerpc/kernel/ibmebus.c
@@ -383,7 +383,8 @@ static int ibmebus_match_path(struct device *dev, void *data)
 
 static char *ibmebus_chomp(const char *in, size_t count)
 {
-	char *out = (char*)kmalloc(count + 1, GFP_KERNEL);
+	char *out = kmalloc(count + 1, GFP_KERNEL);
+
 	if (!out)
 		return NULL;
 
-- 
1.5.2.2

