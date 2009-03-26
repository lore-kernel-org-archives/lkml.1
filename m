Return-Path: <linux-kernel-owner+w=401wt.eu-S1759251AbZCZVkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251AbZCZVkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 17:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757877AbZCZVk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 17:40:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44660 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757597AbZCZVk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 17:40:26 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] firedtv: wrong types in printk
To: linux-kernel@vger.kernel.org, mchehab@infradead.org
Date: Thu, 26 Mar 2009 21:41:15 +0000
Message-ID: <20090326214101.18485.58960.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

size_t is not int...

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/media/dvb/firewire/firedtv-avc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/media/dvb/firewire/firedtv-avc.c b/drivers/media/dvb/firewire/firedtv-avc.c
index b55d9cc..424ed5d 100644
--- a/drivers/media/dvb/firewire/firedtv-avc.c
+++ b/drivers/media/dvb/firewire/firedtv-avc.c
@@ -150,7 +150,7 @@ static void debug_fcp(const u8 *data, size_t length)
 		subunit_type = data[1] >> 3;
 		subunit_id = data[1] & 7;
 		op = subunit_type == 0x1e || subunit_id == 5 ? ~0 : data[2];
-		printk(KERN_INFO "%ssu=%x.%x l=%d: %-8s - %s\n",
+		printk(KERN_INFO "%ssu=%x.%x l=%Zd: %-8s - %s\n",
 		       prefix, subunit_type, subunit_id, length,
 		       debug_fcp_ctype(data[0]),
 		       debug_fcp_opcode(op, data, length));

