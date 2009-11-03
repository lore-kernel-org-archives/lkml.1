Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbZKCTem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbZKCTem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 14:34:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbZKCTem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 14:34:42 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:47102 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbZKCTel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 14:34:41 -0500
Message-ID: <4AF084C6.3020602@nortel.com>
Date: Tue, 03 Nov 2009 13:30:14 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Linux kernel <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Dirk Eibach <eibach@gdsys.de>
Subject: Fwd: [PATCH] arch/powerpc: Improve _memcpy
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Nov 2009 19:33:47.0984 (UTC) FILETIME=[90684500:01CA5CBC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Forwarding to the ppc mailing list.

Chris


-------- Original Message --------
Subject: [PATCH] arch/powerpc: Improve _memcpy
Date: Tue,  3 Nov 2009 15:20:56 +0100
From: Dirk Eibach <eibach@gdsys.de>
To: linux-kernel@vger.kernel.org
CC: Dirk Eibach <eibach@gdsys.de>

The implementation of _memcpy_fromio and _memcpy_toio seems to be
suboptimal for size 4.

Signed-off-by: Dirk Eibach <eibach@gdsys.de>
---
 arch/powerpc/kernel/io.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/io.c b/arch/powerpc/kernel/io.c
index 1882bf4..8dc7547 100644
--- a/arch/powerpc/kernel/io.c
+++ b/arch/powerpc/kernel/io.c
@@ -161,7 +161,7 @@ void _memcpy_fromio(void *dest, const volatile void
__iomem *src,
 		dest++;
 		n--;
 	}
-	while(n > 4) {
+	while(n >= 4) {
 		*((u32 *)dest) = *((volatile u32 *)vsrc);
 		eieio();
 		vsrc += 4;
@@ -190,7 +190,7 @@ void _memcpy_toio(volatile void __iomem *dest, const
void *src, unsigned long n)
 		vdest++;
 		n--;
 	}
-	while(n > 4) {
+	while(n >= 4) {
 		*((volatile u32 *)vdest) = *((volatile u32 *)src);
 		src += 4;
 		vdest += 4;
-- 
1.5.6.5

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

