Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbYELWjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbYELWjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 18:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754929AbYELWjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 18:39:12 -0400
Received: from smtp25.orange.fr ([193.252.22.24]:27948 "EHLO smtp25.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725AbYELWjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 18:39:11 -0400
X-Greylist: delayed 4511 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 May 2008 18:39:11 EDT
X-ME-UUID: 20080512212358722.B05781C00136@mwinf2547.orange.fr
Subject: [PATCH 1/1] AccessRunner: avoid unnecessary memset
From: "Christophe Jaillet" <christophe.jaillet@wanadoo.fr>
To: "cj" <christophe.jaillet@wanadoo.fr>,
       "linux" <linux-kernel@vger.kernel.org>,
       <accessrunner-general@lists.sourceforge.net>
Date: Mon, 12 May 2008 23:23:56 +0200
Content-Type: text/plain
X-Mailer: email v2.5.1 (CYGWIN_NT-5.0 1.5.25(0.156/4/2) i686 [http://email.cleancode.org])
X-Antivirus: avast! (VPS 080512-0, 12/05/2008), Outbound message
X-Antivirus-Status: Clean
Message-Id: <20080512212358.B05781C00136@mwinf2547.orange.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>

Hi, here is a patch against linux/drivers/dma/iop-adma.c which :
	
1) Remove an explicit memset(.., 0, ...) to a variable allocated with
kzalloc (i.e. 'card_info' array of the structure 'instance').


Note: this patch is based on 'linux-2.6.25.tar.bz2'

Signed-off-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>

---

--- linux/drivers/usb/atm/cxacru.c	2008-04-17 04:49:44.000000000 +0200
+++ linux/drivers/usb/atm/cxacru.c.cj	2008-05-12 23:19:18.000000000 +0200
@@ -1050,7 +1050,6 @@ static int cxacru_bind(struct usbatm_dat
 
 	instance->usbatm = usbatm_instance;
 	instance->modem_type = (struct cxacru_modem_type *) id->driver_info;
-	memset(instance->card_info, 0, sizeof(instance->card_info));
 
 	mutex_init(&instance->poll_state_serialize);
 	instance->poll_state = CXPOLL_STOPPED;


