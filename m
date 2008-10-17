Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082AbYJQQFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbYJQQFF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 12:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbYJQQEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 12:04:54 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:42766 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314AbYJQQEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 12:04:54 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] HID: fix hidraw_exit section mismatch
Date: Fri, 17 Oct 2008 18:04:48 +0200
Message-Id: <1224259488-11467-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hidraw_exit() marked as __exit is called from __init function
from HID core. Remove the section placement from that function.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/hid/hidraw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index af3edb9..1c23813 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -403,7 +403,7 @@ out:
 	return result;
 }
 
-void __exit hidraw_exit(void)
+void hidraw_exit(void)
 {
 	dev_t dev_id = MKDEV(hidraw_major, 0);
 
-- 
1.6.0.2

