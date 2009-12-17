Return-Path: <linux-kernel-owner+w=401wt.eu-S1765303AbZLQVOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765303AbZLQVOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 16:14:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764580AbZLQVN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 16:13:59 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:41557 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759972AbZLQVN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 16:13:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=RFWIzsoQFQD/U0rh/YhnVKyTFCjQ+Q+wiGbMnCFJfmXbnSrA5HECRPIjlUknzazcWk
         W3XVV0PAy5MjI9h9IF5eJ7H855i3/+LBOSjZX6W9DWj062vPKaDa2dJMtas0BrfOVO6M
         zAZsJWoTDkp9vdYkYqKk+CJkVA9zP1ALGc3j8=
Message-ID: <4B2A9F8E.5080508@gmail.com>
Date: Thu, 17 Dec 2009 22:15:58 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: Wrong size used in dump_mem()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sizeof the pointed to should be used rather than of the pointer

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Unless I am mistaken?

diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 3f361a7..5e828fa 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -102,7 +102,7 @@ static void dump_mem(const char *lvl, const char *str, unsigned long bottom,
 		unsigned long p;
 		char str[sizeof(" 12345678") * 8 + 1];
 
-		memset(str, ' ', sizeof(str));
+		memset(str, ' ', sizeof(*str));
 		str[sizeof(str) - 1] = '\0';
 
 		for (p = first, i = 0; i < 8 && p < top; i++, p += 4) {
