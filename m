Return-Path: <linux-kernel-owner+w=401wt.eu-S933576AbZKXVHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576AbZKXVHp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:07:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933316AbZKXVHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:07:44 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44501 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933360AbZKXVHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:07:43 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 04/38] move ilo_remove to .devexit.text
Date: Tue, 24 Nov 2009 22:06:59 +0100
Message-Id: <1259096853-18909-4-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1259096853-18909-3-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1259096853-18909-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-2-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-3-git-send-email-u.kleine-koenig@pengutronix.de>
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
Acked-by: David Altobelli <david.altobelli@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Cc: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/misc/hpilo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/hpilo.c b/drivers/misc/hpilo.c
index a92a3a7..487e603 100644
--- a/drivers/misc/hpilo.c
+++ b/drivers/misc/hpilo.c
@@ -716,7 +716,7 @@ out:
 	return error;
 }
 
-static void ilo_remove(struct pci_dev *pdev)
+static void __devexit ilo_remove(struct pci_dev *pdev)
 {
 	int i, minor;
 	struct ilo_hwinfo *ilo_hw = pci_get_drvdata(pdev);
-- 
1.6.5.2

