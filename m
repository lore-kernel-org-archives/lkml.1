Return-Path: <linux-kernel-owner+w=401wt.eu-S932325AbZJAI34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325AbZJAI34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932315AbZJAI3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:29:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56703 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208AbZJAI3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:29:48 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       Yang Hongyang <yanghy@cn.fujitsu.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Alan Cox <alan@redhat.com>, linux-scsi@vger.kernel.org
Subject: [PATCH 08/34] move initio_remove_one to .devexit.text
Date: Thu,  1 Oct 2009 10:28:12 +0200
Message-Id: <1254385718-14254-8-git-send-email-u.kleine-koenig@pengutronix.de>
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

The function initio_remove_one is used only wrapped by __devexit_p so
define it using __devexit.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: Yang Hongyang <yanghy@cn.fujitsu.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@redhat.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/initio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 89a5948..8bbfd99 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2964,7 +2964,7 @@ out_disable_device:
  *	finished being used.
  */
 
-static void initio_remove_one(struct pci_dev *pdev)
+static void __devexit initio_remove_one(struct pci_dev *pdev)
 {
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
 	struct initio_host *s = (struct initio_host *)host->hostdata;
-- 
1.6.4.3

