Return-Path: <linux-kernel-owner+w=401wt.eu-S1753746AbYJTTBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746AbYJTTBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 15:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbYJTTBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 15:01:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46293 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753200AbYJTTBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 15:01:16 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] mfd/wm8350: don't export static functions
Date: Mon, 20 Oct 2008 20:01:13 +0100
Message-Id: <1224529274-9571-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20081020190022.GA9504@rakim.wolfsonmicro.main>
References: <20081020190022.GA9504@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>

Today's linux-next build (powerpc allyesconfig) failed like this:

drivers/mfd/wm8350-core.c:1131: error: __ksymtab_wm8350_create_cache causes a section type conflict

Caused by commit 89b4012befb1abca5e86d232bc0e2a797b0d9825 ("mfd: Core
support for the WM8350 AudioPlus PMIC"). wm8350_create_cache is not used
elsewhere, so remove the EXPORT_SYMBOL.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index bf87f67..fbe22fb 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -1128,7 +1128,6 @@ static int wm8350_create_cache(struct wm8350 *wm8350, int mode)
 out:
 	return ret;
 }
-EXPORT_SYMBOL_GPL(wm8350_create_cache);
 
 /*
  * Register a client device.  This is non-fatal since there is no need to
-- 
1.5.6.5

