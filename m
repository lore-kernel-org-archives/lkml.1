Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbXLKW1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbXLKW1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757302AbXLKWXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:23:52 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38548 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757299AbXLKWXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:23:51 -0500
Date: Tue, 11 Dec 2007 23:23:49 +0100
From: Adrian Bunk <bunk@kernel.org>
To: mchehab@infradead.org
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/media/video/ivtv/ section fix
Message-ID: <20071211222349.GY14204@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatch with CONFIG_HOTPLUG=n:

<--  snip  -->

...
WARNING: vmlinux.o(.text+0x94f07b): Section mismatch: reference to .init.text.20:init_ivtv_i2c (between 'ivtv_process_eeprom' and 'ivtv_init_on_first_open')
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/video/ivtv/ivtv-i2c.c |    2 +-
 drivers/media/video/ivtv/ivtv-i2c.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

e09578fa0df356f5e60b668014a517bab37791c6 
diff --git a/drivers/media/video/ivtv/ivtv-i2c.c b/drivers/media/video/ivtv/ivtv-i2c.c
index 623eea2..77b27dc 100644
--- a/drivers/media/video/ivtv/ivtv-i2c.c
+++ b/drivers/media/video/ivtv/ivtv-i2c.c
@@ -706,7 +706,7 @@ void ivtv_call_i2c_clients(struct ivtv *itv, unsigned int cmd, void *arg)
 }
 
 /* init + register i2c algo-bit adapter */
-int __devinit init_ivtv_i2c(struct ivtv *itv)
+int init_ivtv_i2c(struct ivtv *itv)
 {
 	IVTV_DEBUG_I2C("i2c init\n");
 
diff --git a/drivers/media/video/ivtv/ivtv-i2c.h b/drivers/media/video/ivtv/ivtv-i2c.h
index de6a074..987042c 100644
--- a/drivers/media/video/ivtv/ivtv-i2c.h
+++ b/drivers/media/video/ivtv/ivtv-i2c.h
@@ -35,7 +35,7 @@ int ivtv_call_i2c_client(struct ivtv *itv, int addr, unsigned int cmd, void *arg
 void ivtv_call_i2c_clients(struct ivtv *itv, unsigned int cmd, void *arg);
 
 /* init + register i2c algo-bit adapter */
-int __devinit init_ivtv_i2c(struct ivtv *itv);
+int init_ivtv_i2c(struct ivtv *itv);
 void exit_ivtv_i2c(struct ivtv *itv);
 
 #endif

