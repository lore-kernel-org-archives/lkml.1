Return-Path: <linux-kernel-owner+w=401wt.eu-S1755438AbXLLEBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbXLLEBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 23:01:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbXLLEBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 23:01:36 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:40145 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbXLLEBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 23:01:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:x-mimeole:thread-index;
        b=YS3vXyZKw+7clnJlF4owHZmUCH5NZ0vE5sWzvx6Wpk99TdQ2iDHb1E2hTF45URTnvJ/lf57zfkal/CMthYYlc46tQEQ66Pg+nAltE+Fe+OVOg/0Zv/KczP0NOSo/eJL/d6rOD69G/nM/DTc/tIoJ4Ib0R5VLtfPGGjomkh2S/sE=
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: <jgarzik@pobox.com>, <help@myri.com>
Subject: [PATCH 7/7] [NETDEV]: myri10ge Fix possible causing oops of net_rx_action
Date: Wed, 12 Dec 2007 13:01:27 +0900
Message-ID: <002801c83c73$af10f990$9c94fea9@jason>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Thread-Index: Acg8c6pvdKYp3FioRzeFqxq+BletVw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[NETDEV]: myri10ge Fix possible causing oops of net_rx_action

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
---
 drivers/net/myri10ge/myri10ge.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/myri10ge/myri10ge.c b/drivers/net/myri10ge/myri10ge.c
index 8def865..57311ed 100644
--- a/drivers/net/myri10ge/myri10ge.c
+++ b/drivers/net/myri10ge/myri10ge.c
@@ -1242,6 +1242,8 @@ static int myri10ge_poll(struct napi_struct *napi, int budget)
 	if (work_done < budget || !netif_running(netdev)) {
 		netif_rx_complete(netdev, napi);
 		put_be32(htonl(3), mgp->irq_claim);
+		if (unlikely(work_done == napi->weight))
+			return work_done - 1;
 	}
 	return work_done;
 }
---

