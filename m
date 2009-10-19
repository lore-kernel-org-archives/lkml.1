Return-Path: <linux-kernel-owner+w=401wt.eu-S1755771AbZJSIku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771AbZJSIku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 04:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbZJSIkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 04:40:49 -0400
Received: from mail-pw0-f42.google.com ([209.85.160.42]:56252 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbZJSIkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 04:40:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:x-operating-system:user-agent;
        b=so0/apCqAA5/xssUEprtaigSOzgmw/mznsRnJMR8jJrnAlQdQnQJODGnLHj7NonoH4
         fxzkUR4ItXoe3u1hjf9rJz4kba5x5la9eII4RfuZOSCgNWL79Uxo4vEDdSJ1UQ+CTM27
         So6t8GCOCRzGuUgLwdOnQ7W+wO+HclRuz1TaI=
Date: Mon, 19 Oct 2009 16:33:29 +0800
From: Li Hong <lihong.hi@gmail.com>
To: Borislav Petkov <borislav.petkov@amd.com>,
       Doug Thompson <dougthompson@xmission.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] amd64_edac: fix a wrong goto clause in amd64_edac.c
Message-ID: <20091019083329.GA7340@uhli>
Mail-Followup-To: Borislav Petkov <borislav.petkov@amd.com>,
	Doug Thompson <dougthompson@xmission.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux uhli 2.6.28-11-generic 
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In amd64_edac_init(void) in amd64_edac.c, cache_k8_northbridges() is called
before pci_register_driver. If it fails, should exit with err directly.

Signed-off-by: Li Hong <lihong.hi@gmail.com>
---
 drivers/edac/amd64_edac.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index d4560d9..3ee539a 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -3163,7 +3163,7 @@ static int __init amd64_edac_init(void)
 	opstate_init();
 
 	if (cache_k8_northbridges() < 0)
-		goto err_exit;
+		return err;
 
 	err = pci_register_driver(&amd64_pci_driver);
 	if (err)
@@ -3189,8 +3189,6 @@ static int __init amd64_edac_init(void)
 
 err_2nd_stage:
 	debugf0("2nd stage failed\n");
-
-err_exit:
 	pci_unregister_driver(&amd64_pci_driver);
 
 	return err;
-- 
1.6.0.4

