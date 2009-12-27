Return-Path: <linux-kernel-owner+w=401wt.eu-S1752219AbZL0OIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbZL0OIM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 09:08:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbZL0OIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 09:08:11 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34889 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbZL0OIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 09:08:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Pv59ecpFBEgcKWqu0eaWM919cabiIpa1JFnqPANSIZixvgmQNElNdefW6fmG04ue9O
         81uhs/oHc87/yFoAlaMU5qzLceV02SO+/yThHKsTnaQ6tbWOBUBBSDl3aT4PGkJ1bdk8
         Jjxk0u1GPosJFGVYDOhuDuBBJlrkZI2I6dPi4=
Message-ID: <4B376AF3.6090408@gmail.com>
Date: Sun, 27 Dec 2009 15:10:59 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] niu: timeout ignored in tcam_wait_bit()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With `while (--limit > 0)' i reaches 0 after the loop, so upon timeout the
error was not returned.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/net/niu.c b/drivers/net/niu.c
index 8ce58c4..2aed2b3 100644
--- a/drivers/net/niu.c
+++ b/drivers/net/niu.c
@@ -2844,7 +2844,7 @@ static int tcam_wait_bit(struct niu *np, u64 bit)
 			break;
 		udelay(1);
 	}
-	if (limit < 0)
+	if (limit <= 0)
 		return -ENODEV;
 
 	return 0;
