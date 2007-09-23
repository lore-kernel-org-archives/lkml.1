Return-Path: <linux-kernel-owner+w=401wt.eu-S1757605AbXIWPgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbXIWPgT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 11:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755590AbXIWPgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 11:36:12 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:55435 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555AbXIWPgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 11:36:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding;
	b=Ceh4/iwCX6siUCaAZGOfeELp2yJFIacmS79uf88H0Ly5AjgZPNZJyrNA3KoRJfhTB0mhZ603QQ7N9TT10CbeuPsWvECRLs8QsEreu+LXVqwz9HgXYXqa0KXDLSnVOpUg;
Message-ID: <46F687E8.3010101@simon.arlott.org.uk>
Date: Sun, 23 Sep 2007 16:36:08 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 3/3] cxacru: Cleanup code by removing "ret = ret;" assignments
References: <46F68708.6070409@simon.arlott.org.uk>
In-Reply-To: <46F68708.6070409@simon.arlott.org.uk>
X-Enigmail-Version: 0.95.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup code by removing "ret = ret;" assignments.

Signed-Off-By: Simon Arlott <simon@fire.lp0.eu>
---
 drivers/usb/atm/cxacru.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index 35308a8..bb3169c 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -496,7 +496,6 @@ static int cxacru_cm(struct cxacru_data *instance, enum cxacru_cm_request cm,
 	if (ret < 0) {
 		usb_err(instance->usbatm, "submit of read urb for cm %#x failed (%d)\n",
 			cm, ret);
-		ret = ret;
 		goto fail;
 	}
 
@@ -514,21 +513,18 @@ static int cxacru_cm(struct cxacru_data *instance, enum cxacru_cm_request cm,
 	if (ret < 0) {
 		usb_err(instance->usbatm, "submit of write urb for cm %#x failed (%d)\n",
 			cm, ret);
-		ret = ret;
 		goto fail;
 	}
 
 	ret = cxacru_start_wait_urb(instance->snd_urb, &instance->snd_done, NULL);
 	if (ret < 0) {
 		usb_err(instance->usbatm, "send of cm %#x failed (%d)\n", cm, ret);
-		ret = ret;
 		goto fail;
 	}
 
 	ret = cxacru_start_wait_urb(instance->rcv_urb, &instance->rcv_done, &actlen);
 	if (ret < 0) {
 		usb_err(instance->usbatm, "receive of cm %#x failed (%d)\n", cm, ret);
-		ret = ret;
 		goto fail;
 	}
 	if (actlen % CMD_PACKET_SIZE || !actlen) {
-- 
1.5.0.1

-- 
Simon Arlott
