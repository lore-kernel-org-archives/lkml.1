Return-Path: <linux-kernel-owner+w=401wt.eu-S932264AbZJAI3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264AbZJAI3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932240AbZJAI3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:29:32 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56597 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbZJAI32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:29:28 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       Willem Riede <osst@riede.org>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Ed Lin <ed.lin@promise.com>, Yang Hongyang <yanghy@cn.fujitsu.com>,
       linux-scsi@vger.kernel.org, osst-users@lists.sourceforge.net
Subject: [PATCH 27/34] move stex_remove to .devexit.text
Date: Thu,  1 Oct 2009 10:28:31 +0200
Message-Id: <1254385718-14254-27-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <20091001082607.GA2181@pengutronix.de>
References: <20091001082607.GA2181@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function stex_remove is used only wrapped by __devexit_p so define
it using __devexit.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Willem Riede <osst@riede.org>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: "Kai Mäkisara" <Kai.Makisara@kolumbus.fi>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ed Lin <ed.lin@promise.com>
Cc: Yang Hongyang <yanghy@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org
Cc: osst-users@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/stex.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 09fa886..09ee386 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1679,7 +1679,7 @@ static void stex_hba_free(struct st_hba *hba)
 			  hba->dma_mem, hba->dma_handle);
 }
 
-static void stex_remove(struct pci_dev *pdev)
+static void __devexit stex_remove(struct pci_dev *pdev)
 {
 	struct st_hba *hba = pci_get_drvdata(pdev);
 
-- 
1.6.4.3

