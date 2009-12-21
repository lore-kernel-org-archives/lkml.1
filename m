Return-Path: <linux-kernel-owner+w=401wt.eu-S1753163AbZLUEin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbZLUEin (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 23:38:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbZLUEim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 23:38:42 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:40466 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbZLUEil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 23:38:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=uFOPFeKqtbAcOoULasy3yjCFasqndOVkV58Nwi4TtomdjHbNtCO7+yBcyHd5a7qsaG
         nocRVgHdWJm7T/abucIo47+zUruJHF3MSY25VWBGQ2e5OnXq7y4ecS6GVnQCC4ECK9zu
         lIYVRgNL/LObe2gLRECSBs8v/rESyweLdouPU=
Subject: drivers/edac/ move a kfree() to after last use
From: Darren Jenkins <darrenrjenkins@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dougthompson@xmission.com, borislav.petkov@amd.com
Cc: bluesmoke-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Dec 2009 15:38:26 +1100
Message-ID: <1261370306.11354.52.camel@ICE-BOX>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Move a kfree() below the last use of the memory

Coverity CID: 13142

Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index df5b684..15b8b3c 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2925,10 +2925,10 @@ static void __devexit
amd64_remove_one_instance(struct pci_dev *pdev)
 
 	amd64_free_mc_sibling_devices(pvt);
 
-	kfree(pvt);
 	mci->pvt_info = NULL;
 
 	mci_lookup[pvt->mc_node_id] = NULL;
+	kfree(pvt);
 
 	/* unregister from EDAC MCE */
 	amd_report_gart_errors(false);


