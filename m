Return-Path: <linux-kernel-owner+w=401wt.eu-S1760437AbYEMUNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760437AbYEMUNd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761309AbYEMUMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:12:32 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:50496 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760413AbYEMUMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:12:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=ftWVnsg7ZaxSvM6ey1izRNYX6wYGHqJd1DAH48Kt5bXLXwvxb0NqVlAUaW/Nvaxl2+jzTd3OPNdBywxy/85fDDzG1fZJDEboDG9BWWyI8KOKcQ+uYpCWbbxtQst68Kn/C6VZWKdydsCiNJV56pRkDEpbz9A2C0TyblQ7yP6mpWQ=
Message-ID: <4829F62B.8030003@gmail.com>
Date: Tue, 13 May 2008 22:12:27 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: breed@users.sourceforge.net
CC: linux-wireless@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] wireless, airo: waitbusy() won't delay
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There will be no delay even when COMMAND_BUSY (defined 0x8000) is set:
0x8000 & (delay < 10000) will evaluate to 0 - when delay is 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 45f47c1..efb7444 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -2904,7 +2904,7 @@ EXPORT_SYMBOL(init_airo_card);
 
 static int waitbusy (struct airo_info *ai) {
 	int delay = 0;
-	while ((IN4500 (ai, COMMAND) & COMMAND_BUSY) & (delay < 10000)) {
+	while ((IN4500 (ai, COMMAND) & COMMAND_BUSY) && (delay < 10000)) {
 		udelay (10);
 		if ((++delay % 20) == 0)
 			OUT4500(ai, EVACK, EV_CLEARCOMMANDBUSY);



