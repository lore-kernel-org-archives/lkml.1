Return-Path: <linux-kernel-owner+w=401wt.eu-S1753200AbZGZIV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbZGZIV0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbZGZIVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:21:05 -0400
Received: from www.tglx.de ([62.245.132.106]:33828 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126AbZGZIU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:20:29 -0400
Message-Id: <20090726081556.134234562@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:18:49 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [Patch RFC 22/37] usb: ftdi-elan: Convert "mutex" to semaphore
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline;
	filename=usb-ftdi-elan-use-semaphore-init-instead-of-init-MUTEX.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "mutex" ftdi->sw_lock is used as a lock and a completion. Convert
it to a real semaphore which allows both.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/misc/ftdi-elan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-tip/drivers/usb/misc/ftdi-elan.c
===================================================================
--- linux-2.6-tip.orig/drivers/usb/misc/ftdi-elan.c
+++ linux-2.6-tip/drivers/usb/misc/ftdi-elan.c
@@ -2766,7 +2766,7 @@ static int ftdi_elan_probe(struct usb_in
         ftdi->sequence_num = ++ftdi_instances;
         mutex_unlock(&ftdi_module_lock);
         ftdi_elan_init_kref(ftdi);
-        init_MUTEX(&ftdi->sw_lock);
+	semaphore_init(&ftdi->sw_lock);
         ftdi->udev = usb_get_dev(interface_to_usbdev(interface));
         ftdi->interface = interface;
         mutex_init(&ftdi->u132_lock);


