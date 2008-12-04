Return-Path: <linux-kernel-owner+w=401wt.eu-S1757310AbYLDR1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbYLDR1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbYLDR1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:27:17 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:61305 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbYLDR1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:27:16 -0500
Date: Thu, 4 Dec 2008 09:26:57 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: tiwai@suse.de, akpm <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] sound: fix ca0106 for CONFIG_PM=n
Message-Id: <20081204092657.fb1039c7.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.493812E4.00A5:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build error when CONFIG_PM=n:

sound/pci/ca0106/ca0106_main.c:1809: error: 'snd_ca0106_suspend' undeclared here (not in a function)
sound/pci/ca0106/ca0106_main.c:1810: error: 'snd_ca0106_resume' undeclared here (not in a function)
build-r7018.out:make[4]: *** [sound/pci/ca0106/ca0106_main.o] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 sound/pci/ca0106/ca0106_main.c |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-next-20081204.orig/sound/pci/ca0106/ca0106_main.c
+++ linux-next-20081204/sound/pci/ca0106/ca0106_main.c
@@ -1791,6 +1791,10 @@ static int snd_ca0106_resume(struct pci_
 	snd_power_change_state(card, SNDRV_CTL_POWER_D0);
 	return 0;
 }
+
+#else /* not CONFIG_PM */
+#define snd_ca0106_suspend	NULL
+#define snd_ca0106_resume	NULL
 #endif
 
 // PCI IDs
