Return-Path: <linux-kernel-owner+w=401wt.eu-S932293AbZJAIdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293AbZJAIdX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932253AbZJAIdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:33:21 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56605 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250AbZJAI3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:29:30 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "Brian G. Merrell" <bgmerrell@novell.com>,
       Shan Wei <shanwei@cn.fujitsu.com>, Kay Sievers <kay.sievers@vrfy.org>,
       devel@driverdev.osuosl.org
Subject: [PATCH 28/34] move vhci_hcd_remove to .devexit.text
Date: Thu,  1 Oct 2009 10:28:32 +0200
Message-Id: <1254385718-14254-28-git-send-email-u.kleine-koenig@pengutronix.de>
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

The function vhci_hcd_remove is used only wrapped by __devexit_p so define
it using __devexit.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Brian G. Merrell <bgmerrell@novell.com>
Cc: Shan Wei <shanwei@cn.fujitsu.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/staging/usbip/vhci_hcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index 6e91fc2..22b1c6c 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -1131,7 +1131,7 @@ static int vhci_hcd_probe(struct platform_device *pdev)
 }
 
 
-static int vhci_hcd_remove(struct platform_device *pdev)
+static int __devexit vhci_hcd_remove(struct platform_device *pdev)
 {
 	struct usb_hcd	*hcd;
 
-- 
1.6.4.3

