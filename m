Return-Path: <linux-kernel-owner+w=401wt.eu-S1763402AbYD2TFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763402AbYD2TFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757698AbYD2TFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 15:05:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:1093 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762119AbYD2TF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 15:05:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fPsbl14OuZ0+AxXYS4IZUcEvMi3zqOc52o/UX+2nvxyR+TRlYnnD/xuMMXvjpPJQamyp2wOKt8cKPl+mzGPGtCuf0UDq/1YbrQBEfe3UJGfhXrHjEMKgFEj/P6sq0Lr1j1Z6tX4H64VvjomBlc3PweOqaOOBTct5Ko2r3A6E4WI=
Subject: [BUILDFIX PATCH] proc: pcmcia_ioctl.c remove proc_bus
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 29 Apr 2008 12:05:40 -0700
Message-Id: <1209495941.24729.23.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 9c37066d888bf6e1b96ad12304971b3ddeabbad0 proc: remove proc_bus
missed one user of proc_bus.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/pcmcia/pcmcia_ioctl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pcmcia/pcmcia_ioctl.c b/drivers/pcmcia/pcmcia_ioctl.c
index 27523c5..5f186ab 100644
--- a/drivers/pcmcia/pcmcia_ioctl.c
+++ b/drivers/pcmcia/pcmcia_ioctl.c
@@ -787,7 +787,7 @@ void __init pcmcia_setup_ioctl(void) {
 		major_dev = i;
 
 #ifdef CONFIG_PROC_FS
-	proc_pccard = proc_mkdir("pccard", proc_bus);
+	proc_pccard = proc_mkdir("bus/pccard", NULL);
 	if (proc_pccard)
 		create_proc_read_entry("drivers",0,proc_pccard,proc_read_drivers,NULL);
 #endif
@@ -798,7 +798,7 @@ void __exit pcmcia_cleanup_ioctl(void) {
 #ifdef CONFIG_PROC_FS
 	if (proc_pccard) {
 		remove_proc_entry("drivers", proc_pccard);
-		remove_proc_entry("pccard", proc_bus);
+		remove_proc_entry("bus/pccard", NULL);
 	}
 #endif
 	if (major_dev != -1)
-- 
1.5.5.1.270.g89765



