Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbZG1V4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbZG1V4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 17:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbZG1V4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 17:56:51 -0400
Received: from mx03.kabsi.at ([195.202.128.130]:36657 "EHLO mx03.kabsi.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755007AbZG1V4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 17:56:50 -0400
X-Greylist: delayed 3281 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Jul 2009 17:56:50 EDT
Date: Tue, 28 Jul 2009 23:01:17 +0200
From: Jakob Gruber <jakob.gruber@kabelnet.at>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Missing device IDs in rt2870
Message-Id: <20090728230117.8fca2314.jakob.gruber@kabelnet.at>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From http://bugzilla.kernel.org/show_bug.cgi?id=13459#c3

In rt2870.h, there are 2 lists of USB devices. One is within 

#ifndef RT30xx
#endif

and the other in 

#ifdef RT30xx
#endif

Since I'm not sure whether to add the devices to both lists or only the first,
I'm posting a patch for both variations.

Patch 1, add devices only to first list:

--- a/drivers/staging/rt2870/rt2870.h
+++ b/drivers/staging/rt2870/rt2870.h
@@ -77,6 +77,9 @@
 #ifndef RT30xx
 #define RT2870_USB_DEVICES    \
 {    \
+    {USB_DEVICE(0x2019,0xED14)}, /* Planex Communications, Inc. */
+    {USB_DEVICE(0x1737,0x0070)}, /* Linksys */
+    {USB_DEVICE(0x050D,0x815C)}, /* Belkin */        \
     {USB_DEVICE(0x148F,0x2770)}, /* Ralink */        \
     {USB_DEVICE(0x1737,0x0071)}, /* Linksys WUSB600N */    \
     {USB_DEVICE(0x148F,0x2870)}, /* Ralink */        \

Patch 2, add devices to both lists:

--- a/drivers/staging/rt2870/rt2870.h
+++ b/drivers/staging/rt2870/rt2870.h
@@ -77,6 +77,9 @@
 #ifndef RT30xx
 #define RT2870_USB_DEVICES    \
 {    \
+    {USB_DEVICE(0x2019,0xED14)}, /* Planex Communications, Inc. */
+    {USB_DEVICE(0x1737,0x0070)}, /* Linksys */
+    {USB_DEVICE(0x050D,0x815C)}, /* Belkin */        \
     {USB_DEVICE(0x148F,0x2770)}, /* Ralink */        \
     {USB_DEVICE(0x1737,0x0071)}, /* Linksys WUSB600N */    \
     {USB_DEVICE(0x148F,0x2870)}, /* Ralink */        \
@@ -144,6 +147,9 @@
 #ifdef RT30xx
 #define RT2870_USB_DEVICES    \
 {    \
+    {USB_DEVICE(0x2019,0xED14)}, /* Planex Communications, Inc. */
+    {USB_DEVICE(0x1737,0x0070)}, /* Linksys */
+    {USB_DEVICE(0x050D,0x815C)}, /* Belkin */        \
     {USB_DEVICE(0x148F,0x2770)}, /* Ralink */        \
     {USB_DEVICE(0x148F,0x2870)}, /* Ralink */        \
     {USB_DEVICE(0x148F,0x3070)}, /* Ralink 3070 */    \

Thanks!

-- 
Jakob Gruber <jakob.gruber@kabelnet.at>
