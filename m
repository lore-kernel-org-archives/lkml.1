Return-Path: <linux-kernel-owner+w=401wt.eu-S1753689AbXJaEX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbXJaEX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 00:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbXJaEXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 00:23:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35861
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751967AbXJaEXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 00:23:49 -0400
Date: Tue, 30 Oct 2007 21:23:48 -0700 (PDT)
Message-Id: <20071030.212348.210855016.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: hverkuil@xs4all.nl, linux-kernel@vger.kernel.org
Subject: [PATCH]: exit_ivtv_i2c() cannot be __devexit
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please apply, thanks!

[MEDIA] IVTV: exit_ivtv_i2c() cannot be __devexit

It is referenced both from __devinit code (ivtv_probe) and
normal .text (ivtv_process_eeprom), and therefore cannot
be discarded via __devexit.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/media/video/ivtv/ivtv-i2c.c |    2 +-
 drivers/media/video/ivtv/ivtv-i2c.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtv-i2c.c b/drivers/media/video/ivtv/ivtv-i2c.c
index 285fca6..623eea2 100644
--- a/drivers/media/video/ivtv/ivtv-i2c.c
+++ b/drivers/media/video/ivtv/ivtv-i2c.c
@@ -741,7 +741,7 @@ int __devinit init_ivtv_i2c(struct ivtv *itv)
 		return i2c_bit_add_bus(&itv->i2c_adap);
 }
 
-void __devexit exit_ivtv_i2c(struct ivtv *itv)
+void exit_ivtv_i2c(struct ivtv *itv)
 {
 	IVTV_DEBUG_I2C("i2c exit\n");
 
diff --git a/drivers/media/video/ivtv/ivtv-i2c.h b/drivers/media/video/ivtv/ivtv-i2c.h
index 677c329..de6a074 100644
--- a/drivers/media/video/ivtv/ivtv-i2c.h
+++ b/drivers/media/video/ivtv/ivtv-i2c.h
@@ -36,6 +36,6 @@ void ivtv_call_i2c_clients(struct ivtv *itv, unsigned int cmd, void *arg);
 
 /* init + register i2c algo-bit adapter */
 int __devinit init_ivtv_i2c(struct ivtv *itv);
-void __devexit exit_ivtv_i2c(struct ivtv *itv);
+void exit_ivtv_i2c(struct ivtv *itv);
 
 #endif
