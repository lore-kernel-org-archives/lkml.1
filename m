Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbZLNP1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbZLNP1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 10:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757527AbZLNP1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 10:27:52 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:47244 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757526AbZLNP1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 10:27:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Omi1sVBYkbbl/2wlODyK3TcMvow1QLgQX3NAATpvrqj0uqcDzm8Wn7IieB9ZtFk60Y
         hp1KFp5JVBkniwYm3mZCdL7B2z3MoX6iBiUPZ/bpmymZwee9A1CcZf259z7l2tURPsVB
         KlA/yWi8I7qfLTM4OT9iIyMSpEjFHq34fhgYU=
Message-ID: <4B2659DB.8000309@gmail.com>
Date: Mon, 14 Dec 2009 16:29:31 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Samuel Ortiz <samuel@sortiz.org>, irda-users@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] [IRDA]: ensure that index is within bounds in stir421x_patch_device()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Test whether the index is within bounds before testing the element.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/net/irda/irda-usb.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/irda/irda-usb.c b/drivers/net/irda/irda-usb.c
index e8e33bb..1b0bd32 100644
--- a/drivers/net/irda/irda-usb.c
+++ b/drivers/net/irda/irda-usb.c
@@ -1124,8 +1124,9 @@ static int stir421x_patch_device(struct irda_usb_cb *self)
                  * The actual image starts after the "STMP" keyword
                  * so forward to the firmware header tag
                  */
-                for (i = 0; (fw->data[i] != STIR421X_PATCH_END_OF_HDR_TAG) &&
-			     (i < fw->size); i++) ;
+		for (i = 0; i < fw->size; i++)
+			if (fw->data[i] == STIR421X_PATCH_END_OF_HDR_TAG)
+				break;
                 /* here we check for the out of buffer case */
                 if ((STIR421X_PATCH_END_OF_HDR_TAG == fw->data[i]) &&
                     (i < STIR421X_PATCH_CODE_OFFSET)) {

