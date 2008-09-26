Return-Path: <linux-kernel-owner+w=401wt.eu-S1753552AbYIZT1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbYIZT1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 15:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbYIZT1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 15:27:14 -0400
Received: from lana.hrz.tu-chemnitz.de ([134.109.132.3]:58036 "EHLO
	lana.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbYIZT1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 15:27:13 -0400
From: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
Organization: Chemnitz University of Technology
To: Jarod Wilson <jwilson@redhat.com>
Subject: [PATCH] LIRC: Add missing line breaks
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1840
Cc: Janne Grunau <j@jannau.net>, linux-kernel@vger.kernel.org
Date: Fri, 26 Sep 2008 21:27:16 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200809262127.17034.stefan.bauer@cs.tu-chemnitz.de>
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.5 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: d7bb2b01975254b8f41cda1475e3c4ea
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>

Add missing line breaks to lirc_buffer_{clear, free}() warnings.

Signed-Off-By: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>

---
Jarod, this is for your linux-2.6-lirc.git tree and fixes output like this:
calling lirc_buffer_clear on an uninitialized lirc_bufferModules linked in

diff --git a/drivers/input/lirc/lirc_dev.h b/drivers/input/lirc/lirc_dev.h
index 1342035..bf05a7c 100644
--- a/drivers/input/lirc/lirc_dev.h
+++ b/drivers/input/lirc/lirc_dev.h
@@ -34,7 +34,7 @@ static void lirc_buffer_clear(struct lirc_buffer *buf)
 	if (buf->fifo)
 		kfifo_reset(buf->fifo);
 	else
-		WARN(1, "calling lirc_buffer_clear on an uninitialized lirc_buffer");
+		WARN(1, "calling lirc_buffer_clear on an uninitialized lirc_buffer\n");
 }
 static int lirc_buffer_init(struct lirc_buffer *buf,
 				    unsigned int chunk_size,
@@ -54,7 +54,7 @@ static void lirc_buffer_free(struct lirc_buffer *buf)
 	if (buf->fifo)
 		kfifo_free(buf->fifo);
 	else
-		WARN(1, "calling lirc_buffer_free on an uninitialized lirc_buffer");
+		WARN(1, "calling lirc_buffer_free on an uninitialized lirc_buffer\n");
 }
 static int lirc_buffer_full(struct lirc_buffer *buf)
 {

