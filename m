Return-Path: <linux-kernel-owner+w=401wt.eu-S1752049AbZL0NXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbZL0NXY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 08:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbZL0NXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 08:23:23 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:42066 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbZL0NXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 08:23:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=oEGretqWeA6XffZ4muMB2gohcopDKgQxtShz7w42HofF13sReGHs8glRZpZfnYU+xk
         pri3Fb3/indygkqL93GheJYb6/EzkKaZJbQU8x/W7KckOSRiMqZvqFeYDetXG6jZcDJO
         fLo37Cr8yvPXQuA5kGZGEaWj5/oNUIsX6syJE=
Message-ID: <4B376074.2060305@gmail.com>
Date: Sun, 27 Dec 2009 14:26:12 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] atarilance: timeout ignored in lance_open()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With `while (--i > 0)' i reaches 0 after the loop, so upon timeout the
error was not issued.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/net/atarilance.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/atarilance.c b/drivers/net/atarilance.c
index c5721cb..cc9ed86 100644
--- a/drivers/net/atarilance.c
+++ b/drivers/net/atarilance.c
@@ -663,7 +663,7 @@ static int lance_open( struct net_device *dev )
 	while (--i > 0)
 		if (DREG & CSR0_IDON)
 			break;
-	if (i < 0 || (DREG & CSR0_ERR)) {
+	if (i <= 0 || (DREG & CSR0_ERR)) {
 		DPRINTK( 2, ( "lance_open(): opening %s failed, i=%d, csr0=%04x\n",
 					  dev->name, i, DREG ));
 		DREG = CSR0_STOP;
