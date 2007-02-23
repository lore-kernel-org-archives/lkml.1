Return-Path: <linux-kernel-owner+w=401wt.eu-S933217AbXBWVmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933217AbXBWVmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 16:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933221AbXBWVmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 16:42:32 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:53401 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933217AbXBWVmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 16:42:32 -0500
To: linux-kernel@vger.kernel.org
CC: mpt_linux_developer@lsi.com
Subject: [PATCH] MPT fusion: handle mpt_resume() failure while resuming
From: Dmitriy Monakhov <dmonakhov@openvz.org>
Date: Sat, 24 Feb 2007 00:42:04 +0300
Message-ID: <87bqjkblg3.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [194.85.82.65]); Sat, 24 Feb 2007 00:42:03 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since mpt-fusion-handle-pci-layer-error-on-resume.patch
function mpt_resume() can return error code.

Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
---
 drivers/message/fusion/mptscsih.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index decadbe..96be1d6 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1191,8 +1191,11 @@ mptscsih_resume(struct pci_dev *pdev)
 	MPT_ADAPTER 		*ioc = pci_get_drvdata(pdev);
 	struct Scsi_Host 	*host = ioc->sh;
 	MPT_SCSI_HOST		*hd;
+	int ret;
 
-	mpt_resume(pdev);
+	ret = mpt_resume(pdev);
+	if (ret)
+		return  ret;
 
 	if(!host)
 		return 0;
-- 
1.4.4.4

