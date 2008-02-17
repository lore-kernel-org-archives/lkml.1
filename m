Return-Path: <linux-kernel-owner+w=401wt.eu-S1759167AbYBQMZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759167AbYBQMZ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:25:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757301AbYBQMXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:23:07 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:55053 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755228AbYBQMW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:22:56 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Kylene Hall <kjhall@us.ibm.com>
Subject: [PATCH 19/27] tpm: fix section mismatch warning
Date: Sun, 17 Feb 2008 13:22:56 +0100
Message-Id: <1203250984-11285-19-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080217121255.GA10519@uranus.ravnborg.org>
References: <20080217121255.GA10519@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warning:
WARNING: vmlinux.o(.init.text+0x32804): Section mismatch in reference from the function init_nsc() to the function .devexit.text:tpm_nsc_remove()

The function tpm_nsc_remove() are used outside __exit,
so remove the __exit annotation to make sure the
function is always avilable.

Note: Trying to compare this module with other users of
platform_device gve me the impression that this driver
needs some work to match other users.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Kylene Hall <kjhall@us.ibm.com>
---
 drivers/char/tpm/tpm_nsc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tpm/tpm_nsc.c b/drivers/char/tpm/tpm_nsc.c
index 6313326..ab18c1e 100644
--- a/drivers/char/tpm/tpm_nsc.c
+++ b/drivers/char/tpm/tpm_nsc.c
@@ -264,7 +264,7 @@ static const struct tpm_vendor_specific tpm_nsc = {
 
 static struct platform_device *pdev = NULL;
 
-static void __devexit tpm_nsc_remove(struct device *dev)
+static void tpm_nsc_remove(struct device *dev)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 	if ( chip ) {
-- 
1.5.4.rc3.14.g44397

