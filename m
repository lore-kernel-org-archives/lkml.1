Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696Ab0BRTD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 14:03:27 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45466 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755154Ab0BRTD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 14:03:26 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [RESEND PATCH] dvb: copy_from_user checks
To: mchehab@infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 18 Feb 2010 18:39:16 +0000
Message-ID: <20100218183753.8212.3164.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't believe the frag count can ever get loaded with a negative value
even with the -2 but neither the compiler (nor I ;)) can prove it so keep
us both happy.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/media/dvb/dvb-core/dvb_ca_en50221.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)


diff --git a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
index cb22da5..2cf03e9 100644
--- a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
@@ -1280,7 +1280,7 @@ static ssize_t dvb_ca_en50221_io_write(struct file *file,
 	u8 slot, connection_id;
 	int status;
 	u8 fragbuf[HOST_LINK_BUF_SIZE];
-	int fragpos = 0;
+	unsigned int fragpos = 0;
 	int fraglen;
 	unsigned long timeout;
 	int written;
@@ -1308,6 +1308,8 @@ static ssize_t dvb_ca_en50221_io_write(struct file *file,
 		fraglen = ca->slot_info[slot].link_buf_size - 2;
 		if ((count - fragpos) < fraglen)
 			fraglen = count - fragpos;
+		if (fraglen < 0)
+		        fraglen = 0;
 
 		fragbuf[0] = connection_id;
 		fragbuf[1] = ((fragpos + fraglen) < count) ? 0x80 : 0x00;

