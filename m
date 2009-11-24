Return-Path: <linux-kernel-owner+w=401wt.eu-S934157AbZKXVMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934157AbZKXVMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:12:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934159AbZKXVMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:12:38 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44680 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933549AbZKXVIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:08:34 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Greg Ungerer <gerg@uclinux.org>,
       Len Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 08/38] move mcf_remove to .devexit.text
Date: Tue, 24 Nov 2009 22:07:03 +0100
Message-Id: <1259096853-18909-8-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1259096853-18909-7-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1259096853-18909-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-2-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-3-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-4-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-5-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-6-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-7-git-send-email-u.kleine-koenig@pengutronix.de>
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

The function mcf_remove is used only wrapped by __devexit_p so define it
using __devexit.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Len Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
---
 drivers/serial/mcf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/mcf.c b/drivers/serial/mcf.c
index b443824..7bb5fee 100644
--- a/drivers/serial/mcf.c
+++ b/drivers/serial/mcf.c
@@ -602,7 +602,7 @@ static int __devinit mcf_probe(struct platform_device *pdev)
 
 /****************************************************************************/
 
-static int mcf_remove(struct platform_device *pdev)
+static int __devexit mcf_remove(struct platform_device *pdev)
 {
 	struct uart_port *port;
 	int i;
-- 
1.6.5.2

