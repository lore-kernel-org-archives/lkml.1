Return-Path: <linux-kernel-owner+w=401wt.eu-S1761227AbZCXOOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761227AbZCXOOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759411AbZCXOG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:06:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34003 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759324AbZCXOG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:06:26 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 27/30] ucc: Fix leaky error path
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       torvalds@linux-foundation.org
Date: Tue, 24 Mar 2009 14:06:34 +0000
Message-ID: <20090324140625.12735.27551.stgit@localhost.localdomain>
In-Reply-To: <20090324135930.12735.7827.stgit@localhost.localdomain>
References: <20090324135930.12735.7827.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found by Daniel Marjamäki using cppcheck

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/serial/ucc_uart.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/drivers/serial/ucc_uart.c b/drivers/serial/ucc_uart.c
index 315a933..7de66c0 100644
--- a/drivers/serial/ucc_uart.c
+++ b/drivers/serial/ucc_uart.c
@@ -1274,6 +1274,7 @@ static int ucc_uart_probe(struct of_device *ofdev,
 	if (!iprop) {
 		iprop = of_get_property(np, "device-id", NULL);
 		if (!iprop) {
+			kfree(qe_port);
 			dev_err(&ofdev->dev, "UCC is unspecified in "
 				"device tree\n");
 			return -EINVAL;

