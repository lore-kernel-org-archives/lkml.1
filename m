Return-Path: <linux-kernel-owner+w=401wt.eu-S1757057AbZDFPiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbZDFPiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbZDFPfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:35:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56988 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751266AbZDFPfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:35:18 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 15/27] ucc: Fix leaky error path
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 06 Apr 2009 17:33:48 +0100
Message-ID: <20090406163342.12934.87419.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
References: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
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

