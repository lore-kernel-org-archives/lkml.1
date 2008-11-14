Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbYKNT1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbYKNT1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 14:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbYKNT1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 14:27:23 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:37440 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbYKNT1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 14:27:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=X1E1tne5Xs+1IE1/6o5lq/EyBHFLv91oQGCWiM9IvA+emwf/YljrNbGNLtBUUBQaon
         KnaM59xwMMktf8CX8ruBRkEyl5WFUUJomW38P8zAQskNt1XGhQ0Q+CJk4Tt4dVFkpj7s
         +2mccvue0iXMLgiG7IT45z5lddHL31MXRJNRI=
Subject: [PATCH] v4l: s2255drv fix firmware test on big-endian
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-maintainer <v4l-dvb-maintainer@linuxtv.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 14 Nov 2008 11:27:14 -0800
Message-Id: <1226690834.5483.40.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed by sparse:
drivers/media/video/s2255drv.c:2531:6: warning: restricted __le32 degrades to integer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/media/video/s2255drv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index 5272926..3c3f8cf 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -192,7 +192,7 @@ struct s2255_dmaqueue {
 #define S2255_FW_FAILED		3
 #define S2255_FW_DISCONNECTING  4
 
-#define S2255_FW_MARKER         0x22552f2f
+#define S2255_FW_MARKER		cpu_to_le32(0x22552f2f)
 /* 2255 read states */
 #define S2255_READ_IDLE         0
 #define S2255_READ_FRAME        1
-- 
1.6.0.4.879.g9d19a



