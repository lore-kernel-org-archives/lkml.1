Return-Path: <linux-kernel-owner+w=401wt.eu-S932398AbZJAIft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398AbZJAIft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932234AbZJAIfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:35:38 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56550 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207AbZJAI3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:29:23 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       David Altobelli <david.altobelli@hp.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/34] move ilo_remove to .devexit.text
Date: Thu,  1 Oct 2009 10:28:11 +0200
Message-Id: <1254385718-14254-7-git-send-email-u.kleine-koenig@pengutronix.de>
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

The function ilo_remove is used only wrapped by __devexit_p so define it
using __devexit.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: David Altobelli <david.altobelli@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
---
 drivers/misc/hpilo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/hpilo.c b/drivers/misc/hpilo.c
index 1ad27c6..9ec007e 100644
--- a/drivers/misc/hpilo.c
+++ b/drivers/misc/hpilo.c
@@ -715,7 +715,7 @@ out:
 	return error;
 }
 
-static void ilo_remove(struct pci_dev *pdev)
+static void __devexit ilo_remove(struct pci_dev *pdev)
 {
 	int i, minor;
 	struct ilo_hwinfo *ilo_hw = pci_get_drvdata(pdev);
-- 
1.6.4.3

