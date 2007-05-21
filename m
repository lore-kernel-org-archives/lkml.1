Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbXEUQwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbXEUQwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756017AbXEUQwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:52:41 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38718 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571AbXEUQwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:52:40 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 21 May 2007 18:52:06 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: raw1394: Add ioctl() for 32bit userland on 64bit
 kernel, amendment
To: linux1394-devel@lists.sourceforge.net
cc: Dan Dennedy <dan@dennedy.org>, Arnd Bergmann <arnd@arndb.de>,
       Petr Vandrovec <petr@vandrovec.name>, linux-kernel@vger.kernel.org
In-Reply-To: <46514A01.5090803@s5r6.in-berlin.de>
Message-ID: <tkrat.e7d6bff54a497889@s5r6.in-berlin.de>
References: <20070507021447.GA22197@vana.vc.cvut.cz>
 <200705200155.26825.arnd@arndb.de> <464F900A.10900@s5r6.in-berlin.de>
 <200705201703.37561.arnd@arndb.de> <46506912.9020904@s5r6.in-berlin.de>
 <46514A01.5090803@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pointed out by Arnd Bergmann:  PPC32 aligns this at 64bit, IA32 packs
it.  A kernel-wide available __compat_u64 which is 4-byte aligned on
AMD64 and IA64 would be nicer though.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/raw1394.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux/drivers/ieee1394/raw1394.c
===================================================================
--- linux.orig/drivers/ieee1394/raw1394.c
+++ linux/drivers/ieee1394/raw1394.c
@@ -2814,7 +2814,11 @@ struct raw1394_iso_packets32 {
 struct raw1394_cycle_timer32 {
         __u32 cycle_timer;
         __u64 local_time;
-} __attribute__((packed));
+}
+#if defined(CONFIG_X86_64) || defined(CONFIG_IA64)
+__attribute__((packed))
+#endif
+;
 
 #define RAW1394_IOC_ISO_RECV_PACKETS32          \
         _IOW ('#', 0x25, struct raw1394_iso_packets32)

-- 
Stefan Richter
-=====-=-=== -=-= =-=-=
http://arcgraph.de/sr/

