Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbZLZS6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbZLZS6K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 13:58:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbZLZS6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 13:58:05 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:36658 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbZLZS6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 13:58:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=NQZMXSc/nkr2hulgGMTgALqgyPS3FUwgrF/Id8318XkWUdqj23CN8so6nMsq6TDdbV
         BnqdJpbMkjB/hsFrF16py/4CsDRPVvfCIX91gmdASxyakjYuGIIIrynWOjdoqpgLRHOS
         UDOKSY9lEjtTE2a5UgaUSssAYeyC9ZYUUgzFI=
Message-ID: <4B365D5F.70105@gmail.com>
Date: Sat, 26 Dec 2009 20:00:47 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, bzolnier@gmail.com
Subject: [PATCH] rt2860: test off by one in RtmpAsicSendCommandToMcu()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`i' reaches 101 after the loop, so if it was 100 then it succeeded in
the last iteration. This is probably unlikely to cause problems.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/staging/rt2860/common/rtmp_mcu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rt2860/common/rtmp_mcu.c b/drivers/staging/rt2860/common/rtmp_mcu.c
index 9f03901..e80f587 100644
--- a/drivers/staging/rt2860/common/rtmp_mcu.c
+++ b/drivers/staging/rt2860/common/rtmp_mcu.c
@@ -221,7 +221,7 @@ int RtmpAsicSendCommandToMcu(struct rt_rtmp_adapter *pAd,
 				 ("AsicSendCommanToMcu::Mail box is busy\n"));
 		} while (i++ < 100);
 
-		if (i >= 100) {
+		if (i > 100) {
 			DBGPRINT_ERR(("H2M_MAILBOX still hold by MCU. command fail\n"));
 			return FALSE;
 		}
