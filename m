Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbYELW4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbYELW4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 18:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755538AbYELW4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 18:56:09 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:37681 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754989AbYELW4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 18:56:08 -0400
X-Greylist: delayed 2031 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 May 2008 18:56:07 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding;
	b=P8RMX3EWVFYTXe5hr9LwJJOhNy6Ps7zdY0OJUJcS/Uehy/pqrAW7TCpFw32Sn91fGwRp/a0EQnK4Mq3lgpunPomt5PrR1hmQV8DL8nahS4ogxk4A4vabY/3aqw+KtKho;
Message-ID: <4828C316.70101@simon.arlott.org.uk>
Date: Mon, 12 May 2008 23:22:14 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@vger.kernel.org
CC: christophe.jaillet@wanadoo.fr
Subject: [PATCH] cxacru: avoid unnecessary memset
X-Enigmail-Version: 0.95.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>

Remove an explicit memset(.., 0, ...) to a variable allocated with
kzalloc (i.e. 'card_info' array of the structure 'instance').

Signed-off-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---

 drivers/usb/atm/cxacru.c |   1 -
 1 file changed, 1 deletions(-)

--- a/drivers/usb/atm/cxacru.c	2008-04-17 04:49:44.000000000 +0200
+++ b/drivers/usb/atm/cxacru.c	2008-05-12 23:19:18.000000000 +0200
@@ -1050,7 +1050,6 @@ static int cxacru_bind(struct usbatm_dat
 
 	instance->usbatm = usbatm_instance;
 	instance->modem_type = (struct cxacru_modem_type *) id->driver_info;
-	memset(instance->card_info, 0, sizeof(instance->card_info));
 
 	mutex_init(&instance->poll_state_serialize);
 	instance->poll_state = CXPOLL_STOPPED;



-- 
Simon Arlott
