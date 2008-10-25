Return-Path: <linux-kernel-owner+w=401wt.eu-S1752630AbYJYWa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbYJYWa2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 18:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbYJYWaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 18:30:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45929 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbYJYWaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 18:30:20 -0400
From: Andreas Schwab <schwab@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix hid_device_id for cross compiling
Cc: linux-input@ver.kernel.org
X-Yow: I LIKE Aisle 7a.
Date: Sun, 26 Oct 2008 00:30:18 +0200
Message-ID: <jevdvgl345.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct hid_device_id contains hidden padding which is bad for cross
compiling.  Make the padding explicit and consistent across
architectures.

Signed-off-by: Andreas Schwab <schwab@suse.de>
---
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index eb71b45..0e4f303 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -135,6 +135,7 @@ struct usb_device_id {
 
 struct hid_device_id {
 	__u16 bus;
+	__u16 pad1;
 	__u32 vendor;
 	__u32 product;
 	kernel_ulong_t driver_data

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
