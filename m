Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbXLLSjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbXLLSjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 13:39:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757020AbXLLSiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 13:38:50 -0500
Received: from mailbox2.myri.com ([64.172.73.26]:2027 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755709AbXLLSis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 13:38:48 -0500
Message-ID: <47602AAA.8060204@myri.com>
Date: Wed, 12 Dec 2007 13:38:34 -0500
From: Andrew Gallatin <gallatin@myri.com>
User-Agent: Thunderbird 1.5.0.7 (Macintosh/20060909)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Jeff Garzik <jeff@garzik.org>, netdev <netdev@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH][NETDEV]: remove netif_running() check from myri10ge_poll()
Content-Type: multipart/mixed;
 boundary="------------020002040506070505020508"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020002040506070505020508
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Remove the bogus netif_running() check from myri10ge_poll().

This eliminates any chance that myri10ge_poll() can trigger
an oops by calling netif_rx_complete() and returning
with work_done == budget.

Signed-off-by: Andrew Gallatin <gallatin@myri.com>

--------------020002040506070505020508
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
 name="myri10ge_remove_netif_running.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="myri10ge_remove_netif_running.diff"

diff --git a/drivers/net/myri10ge/myri10ge.c b/drivers/net/myri10ge/myri10ge.c
index 8def865..c90958f 100644
--- a/drivers/net/myri10ge/myri10ge.c
+++ b/drivers/net/myri10ge/myri10ge.c
@@ -1239,7 +1239,7 @@ static int myri10ge_poll(struct napi_str
 	/* process as many rx events as NAPI will allow */
 	work_done = myri10ge_clean_rx_done(mgp, budget);
 
-	if (work_done < budget || !netif_running(netdev)) {
+	if (work_done < budget) {
 		netif_rx_complete(netdev, napi);
 		put_be32(htonl(3), mgp->irq_claim);
 	}

--------------020002040506070505020508--
