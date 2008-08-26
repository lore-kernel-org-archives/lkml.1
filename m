Return-Path: <linux-kernel-owner+w=401wt.eu-S1759542AbYHZUET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542AbYHZUET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 16:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbYHZUD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 16:03:58 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:4957 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759287AbYHZUD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 16:03:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=i2ebOhE0nmYNXr4nevOIQS4NEGa5ZXeZo45lmXWmA4WrCMQzMM/qCETiS0JWLOpzBi
         kApioRagUjBJFjkn0U4uwv+cD1E5YtV9S6u2BtzdEwGEwINCDQ9rCNhNW+2KRNbUS1tx
         ygtro3x5762ydWK/Lf6iu828rdSp47HieCWkI=
Subject: [PATCH] acpi: toshiba_acpi.c fix sparse signedness mismatch
	warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 26 Aug 2008 13:03:54 -0700
Message-Id: <1219781034.6069.8.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set_bit expects unsigned int, and we start with a u32 anyway.
drivers/acpi/toshiba_acpi.c:397:14: warning: incorrect type in argument 1 (different signedness)
drivers/acpi/toshiba_acpi.c:397:14:    expected unsigned int [usertype] *word
drivers/acpi/toshiba_acpi.c:397:14:    got int *<noident>
drivers/acpi/toshiba_acpi.c:399:14: warning: incorrect type in argument 1 (different signedness)
drivers/acpi/toshiba_acpi.c:399:14:    expected unsigned int [usertype] *word
drivers/acpi/toshiba_acpi.c:399:14:    got int *<noident>
drivers/acpi/toshiba_acpi.c:401:14: warning: incorrect type in argument 1 (different signedness)
drivers/acpi/toshiba_acpi.c:401:14:    expected unsigned int [usertype] *word
drivers/acpi/toshiba_acpi.c:401:14:    got int *<noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/acpi/toshiba_acpi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/toshiba_acpi.c b/drivers/acpi/toshiba_acpi.c
index 0a43c8e..4172d29 100644
--- a/drivers/acpi/toshiba_acpi.c
+++ b/drivers/acpi/toshiba_acpi.c
@@ -392,7 +392,7 @@ static unsigned long write_video(const char *buffer, unsigned long count)
 
 	hci_read1(HCI_VIDEO_OUT, &video_out, &hci_result);
 	if (hci_result == HCI_SUCCESS) {
-		int new_video_out = video_out;
+		unsigned int new_video_out = video_out;
 		if (lcd_out != -1)
 			_set_bit(&new_video_out, HCI_VIDEO_OUT_LCD, lcd_out);
 		if (crt_out != -1)
-- 
1.6.0.340.g84854



