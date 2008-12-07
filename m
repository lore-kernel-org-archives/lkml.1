Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbYLGCdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbYLGCdE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 21:33:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbYLGCcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 21:32:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:7476 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbYLGCcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 21:32:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=VjredgoJ/YI6ZIBaXBB+PupiOeDN7bbZrqnarYhaLNWPtJ6FCO0Rx7+DGYoxK7m3dd
         GkrngrYHrLqvtBDxZU60SzJ+QCdpcl96PNcUKoTfXOoZiVzs6z8xTMogVnpewaEu6i7/
         7ApdXdi2XHThOFaG/DcqC5tJuN7YU+iYey1Ug=
Date: Sun, 7 Dec 2008 05:32:46 +0300
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, adobriyan@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Staging/usbip: switch to list_for_each_entry()
Message-ID: <20081207023246.GB21294@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/staging/usbip/stub_rx.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/usbip/stub_rx.c b/drivers/staging/usbip/stub_rx.c
index 2a2cc0f..2eb6137 100644
--- a/drivers/staging/usbip/stub_rx.c
+++ b/drivers/staging/usbip/stub_rx.c
@@ -234,8 +234,6 @@ static void tweak_special_requests(struct urb *urb)
 static int stub_recv_cmd_unlink(struct stub_device *sdev,
 						struct usbip_header *pdu)
 {
-	struct list_head *listhead = &sdev->priv_init;
-	struct list_head *ptr;
 	unsigned long flags;
 
 	struct stub_priv *priv;
@@ -243,8 +241,7 @@ static int stub_recv_cmd_unlink(struct stub_device *sdev,
 
 	spin_lock_irqsave(&sdev->priv_lock, flags);
 
-	for (ptr = listhead->next; ptr != listhead; ptr = ptr->next) {
-		priv = list_entry(ptr, struct stub_priv, list);
+	list_for_each_entry(priv, &sdev->priv_init, list) {
 		if (priv->seqnum == pdu->u.cmd_unlink.seqnum) {
 			int ret;
 
