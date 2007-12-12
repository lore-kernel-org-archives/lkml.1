Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbXLLECX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbXLLECX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 23:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbXLLEBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 23:01:43 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:40145 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbXLLEBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 23:01:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:x-mimeole:thread-index;
        b=c1vCrW1Nrhx6lS3pC6zPGQh0Qnw2x/CnXrmdHxTd9qj0BYOpbL3u0nd/SAHU6QlgzfRb+YyvQZ2igf3unDFjbDqYZNFdeQJPWI/vN6lYB+c7A9op5hgh20hTzkrSWICS02yoUBNa+deutzcUOkiaDnirS/w9ANXZKT3VFF4D+P8=
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: "'Kok, Auke'" <auke-jan.h.kok@intel.com>, <jesse.brandeburg@intel.com>,
       <jgarzik@pobox.com>
Subject: [PATCH 5/7] [NETDEV]: e100 Fix possible causing oops of net_rx_action
Date: Wed, 12 Dec 2007 13:01:27 +0900
Message-ID: <002a01c83c73$b1a7d110$9c94fea9@jason>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Thread-Index: Acg8c6gN3bui1HeXQb22YAD5lRV/sQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[NETDEV]: e100 Fix possible causing oops of net_rx_action

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
---
 drivers/net/e100.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/e100.c b/drivers/net/e100.c
index e1c8a0d..7cb4ed0 100644
--- a/drivers/net/e100.c
+++ b/drivers/net/e100.c
@@ -2000,6 +2000,8 @@ static int e100_poll(struct napi_struct *napi, int budget)
 	if((!tx_cleaned && (work_done == 0)) || !netif_running(netdev)) {
 		netif_rx_complete(netdev, napi);
 		e100_enable_irq(nic);
+		if (unlikely(work_done == napi->weight))
+			return work_done - 1;
 	}
 
 	return work_done;
---

