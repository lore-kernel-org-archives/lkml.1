Return-Path: <linux-kernel-owner+w=401wt.eu-S1759399AbYKVRf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399AbYKVRf2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759235AbYKVRe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:34:26 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55344 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759227AbYKVReZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:34:25 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH 7/32] fix talitos
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1L3wNE-0006Mc-Io@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:34:24 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


talitos_remove() can be called from talitos_probe() on failure
exit path, so it can't be __devexit.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/crypto/talitos.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1357,7 +1357,7 @@ static int hw_supports(struct device *dev, __be32 desc_hdr_template)
 	return ret;
 }
 
-static int __devexit talitos_remove(struct of_device *ofdev)
+static int talitos_remove(struct of_device *ofdev)
 {
 	struct device *dev = &ofdev->dev;
 	struct talitos_private *priv = dev_get_drvdata(dev);
@@ -1622,7 +1622,7 @@ static struct of_platform_driver talitos_driver = {
 	.name = "talitos",
 	.match_table = talitos_match,
 	.probe = talitos_probe,
-	.remove = __devexit_p(talitos_remove),
+	.remove = talitos_remove,
 };
 
 static int __init talitos_init(void)
