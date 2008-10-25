Return-Path: <linux-kernel-owner+w=401wt.eu-S1753903AbYJYQ7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbYJYQ7W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 12:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbYJYQ7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 12:59:13 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:41616 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbYJYQ7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 12:59:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=d4Ag4cz0ApNZsICKRqUNoyedRw4ehLTSgzWtqWKCzY3iuxgop9eBtmmby+4eOwjFFY
         J5YfAJnJ2QOMArbr8YqblZUJrgGX2BF3BdjYnhKskRpKyzEAiWov5RQGiBL/GZQW/eg7
         ha2tnPpnfSmnGJYP8QvDETmldaSuVpvDPAPtQ=
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: jason.wessel@windriver.com
Subject: [PATCH RESEND]kgdb:remove redundant function invocation
Date: Sun, 26 Oct 2008 00:59:06 +0800
User-Agent: KMail/1.9.10
Cc: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810260059.06203.qhfeng.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for my resending, the previous patch can't be applied successfully.

It seems strange to call kgdboc_option_setup with parameter of config from 
configure_kgdboc(), because kgdboc_option_setup() is used to fill config
with stuff in other place. Now, kgdboc_option_setup will fill config
with config itself. But on the other hand, kgdboc_option_setup has a 
additional effect to check whether config overflows or not.

Is it ok to remove kgdboc_option_setup? 

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
index eadc1ab..03f683e 100644
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -51,8 +51,7 @@ static int configure_kgdboc(void)
 	int tty_line = 0;
 	int err;
 
-	err = kgdboc_option_setup(config);
-	if (err || !strlen(config) || isspace(config[0]))
+	if (!strlen(config) || isspace(config[0]))
 		goto noconfig;
 
 	err = -ENODEV;
