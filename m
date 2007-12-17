Return-Path: <linux-kernel-owner+w=401wt.eu-S933533AbXLQQGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933533AbXLQQGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758987AbXLQQGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:06:08 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:37964 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759334AbXLQQGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:06:07 -0500
Message-ID: <47669E48.4030109@tiscali.nl>
Date: Mon, 17 Dec 2007 17:05:28 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: mac@melware.de
CC: isdn4linux@listserv.isdn4linux.de, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH drivers/isdn/hardware/eicon/message.c] fix 'and' typo in eicons'
 AddInfo()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have previously sent this to isdn4linux@listserv.isdn4linux.de and its
maintainer, but the error is still in linus' tree.
--
'!' has a higher priority than '&', so as was the bit test masks a binary.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/isdn/hardware/eicon/message.c b/drivers/isdn/hardware/eicon/message.c
index ccd35d0..189b231 100644
--- a/drivers/isdn/hardware/eicon/message.c
+++ b/drivers/isdn/hardware/eicon/message.c
@@ -9027,7 +9027,7 @@ static byte AddInfo(byte   **add_i,
    /* facility is a nested structure */
    /* FTY can be more than once      */
 
-  if(esc_chi[0] && !(esc_chi[esc_chi[0]])&0x7f )
+	if (esc_chi[0] && !(esc_chi[esc_chi[0]] & 0x7f))
   {
     add_i[0] = (byte   *)"\x02\x02\x00"; /* use neither b nor d channel */
   }
