Return-Path: <linux-kernel-owner+w=401wt.eu-S1761065AbYBGOaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761065AbYBGOaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 09:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755591AbYBGO3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 09:29:37 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:49843 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112AbYBGO3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 09:29:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=IE44h+xhe9OfCRUgFtQB6atKZlUW1x6uMYYr+T1mshwjYw8Z1crbmdNu90uw3Y7GxdId79bC8EqECOsr3AQDWenxYsjKMjstsRrowItjn1hDz9X1TRCHBMk62BX2eR2IWm8dUWLTjGKTt/tlxbJNxJfwMAEzxnXrji2G0JR1EZE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/3] palm_bk3710: fix ide_unregister() usage
Date: Thu, 7 Feb 2008 15:42:00 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, Anton Salnikov <asalnikov@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802071542.00438.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Don't set 'restore' flag for ide_unregister() when initializing new
interface.

[ identical change as done to bast-ide/ide-cs/delkin_cb host drivers
  by commit 909f4369bca30f9a186316a3bf2b4a9c1e702a25 ]

Cc: Anton Salnikov <asalnikov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/palm_bk3710.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/arm/palm_bk3710.c
===================================================================
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -363,7 +363,7 @@ static int __devinit palm_bk3710_probe(s
 	i = hwif->index;
 
 	if (hwif->present)
-		ide_unregister(i, 0, 1);
+		ide_unregister(i, 0, 0);
 	else if (!hwif->hold)
 		ide_init_port_data(hwif, i);
 
