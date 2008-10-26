Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbYJZHQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbYJZHQn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 03:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbYJZHQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 03:16:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:14695 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbYJZHQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 03:16:33 -0400
Message-ID: <4904194D.1080806@larces.uece.br>
Date: Sun, 26 Oct 2008 04:16:29 -0300
From: Sergio Luis <sergio@larces.uece.br>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 1/2] btsdio: free sk_buff with kfree_skb
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

free sk_buff with kfree_skb, instead of kree
 
Signed-off-by: Sergio Luis <sergio@larces.uece.br>
Cc: Marcel Holtmann <marcel@holtmann.org>

drivers/bluetooth/btsdio.c         |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btsdio.c b/drivers/bluetooth/btsdio.c
index 58630cc..cda6c7c 100644
--- a/drivers/bluetooth/btsdio.c
+++ b/drivers/bluetooth/btsdio.c
@@ -152,7 +152,7 @@ static int btsdio_rx_packet(struct btsdio_data *data)
 
 	err = sdio_readsb(data->func, skb->data, REG_RDAT, len - 4);
 	if (err < 0) {
-		kfree(skb);
+		kfree_skb(skb);
 		return err;
 	}
 
