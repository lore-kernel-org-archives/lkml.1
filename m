Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbZBIWW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbZBIWW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 17:22:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbZBIWWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 17:22:13 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:26140 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbZBIWWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 17:22:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=XQAhJ/rQhvQDmU/G0SHYycTF9UBuvR7Yg2emQ/sMmPiStOgxkTrOaDhp07HYXjO62h
         rOJOUz1gxuNEbZqZCuomBymsvhAkjXsnsrtQSqX2/s9J6uUxgsY7M7PIwlE90BqEWnbv
         IM22Vqk0/2A5HkrS7bwU9ov3NyNt62c5/Qq5I=
Message-ID: <4990AC93.3080906@gmail.com>
Date: Mon, 09 Feb 2009 23:22:11 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>
CC: netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] netdevice: ticks reaches 25, not 26.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With while (tick++ < 25) { ... } ticks reaches 25, not 26.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/net/myri_sbus.c b/drivers/net/myri_sbus.c
index 899ed06..a95e217 100644
--- a/drivers/net/myri_sbus.c
+++ b/drivers/net/myri_sbus.c
@@ -161,7 +161,7 @@ static int myri_do_handshake(struct myri_eth *mp)
 
 	myri_enable_irq(mp->lregs, cregs);
 
-	if (tick > 25) {
+	if (tick >= 25) {
 		DET(("25 ticks we lose, failure.\n"));
 		return -1;
 	}
