Return-Path: <linux-kernel-owner+w=401wt.eu-S932688AbZDAOMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688AbZDAOMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 10:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765817AbZDAOGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 10:06:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37777 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932271AbZDAOGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 10:06:20 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 15/24] ucc: Fix leaky error path
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Date: Wed, 01 Apr 2009 15:06:32 +0100
Message-ID: <20090401140629.22882.73409.stgit@localhost.localdomain>
In-Reply-To: <20090401140241.22882.93477.stgit@localhost.localdomain>
References: <20090401140241.22882.93477.stgit@localhost.localdomain>
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

