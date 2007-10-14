Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbXJNFBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbXJNFBW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 01:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbXJNFBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 01:01:14 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:50242
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbXJNFBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 01:01:13 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: akpm@linux-foundation.org
Subject: [PATCH] Fix "make htmldocs" build break.
Date: Sun, 14 Oct 2007 00:01:06 -0500
User-Agent: KMail/1.9.6
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710140001.06489.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Fix two htmldocs build breaks, introduced by moving include/linux/usb_gadget.h to
include/linux/usb/gadget.h and combining resume.c and suspend.c into main.c in
drivers/base/power.

Signed-off-by: Rob Landley <rob@landley.net>
---

 Documentation/DocBook/gadget.tmpl     |    6 +++---
 Documentation/DocBook/kernel-api.tmpl |    3 +--
 2 files changed, 4 insertions(+), 5 deletions(-)

diff -r aa4dbd059380 Documentation/DocBook/gadget.tmpl
--- a/Documentation/DocBook/gadget.tmpl	Sat Oct 13 18:16:49 2007 -0700
+++ b/Documentation/DocBook/gadget.tmpl	Sat Oct 13 23:51:56 2007 -0500
@@ -144,7 +144,7 @@ with the lowest level (which directly ha
 	<para>This is the lowest software level.
 	It is the only layer that talks to hardware,
 	through registers, fifos, dma, irqs, and the like.
-	The <filename>&lt;linux/usb_gadget.h&gt;</filename> API abstracts
+	The <filename>&lt;linux/usb/gadget.h&gt;</filename> API abstracts
 	the peripheral controller endpoint hardware.
 	That hardware is exposed through endpoint objects, which accept
 	streams of IN/OUT buffers, and through callbacks that interact
@@ -494,7 +494,7 @@ side drivers (and usbcore).
 <sect1 id="core"><title>Core Objects and Methods</title>
 
 <para>These are declared in
-<filename>&lt;linux/usb_gadget.h&gt;</filename>,
+<filename>&lt;linux/usb/gadget.h&gt;</filename>,
 and are used by gadget drivers to interact with
 USB peripheral controller drivers.
 </para>
@@ -509,7 +509,7 @@ USB peripheral controller drivers.
 	     unless the explanations are trivial.
 	  -->
 
-!Iinclude/linux/usb_gadget.h
+!Iinclude/linux/usb/gadget.h
 </sect1>
 
 <sect1 id="utils"><title>Optional Utilities</title>
diff -r aa4dbd059380 Documentation/DocBook/kernel-api.tmpl
--- a/Documentation/DocBook/kernel-api.tmpl	Sat Oct 13 18:16:49 2007 -0700
+++ b/Documentation/DocBook/kernel-api.tmpl	Sat Oct 13 23:51:56 2007 -0500
@@ -386,8 +386,7 @@ X!Edrivers/base/interface.c
 !Edrivers/base/bus.c
      </sect1>
      <sect1><title>Device Drivers Power Management</title>
-!Edrivers/base/power/resume.c
-!Edrivers/base/power/suspend.c
+!Edrivers/base/power/main.c
      </sect1>
      <sect1><title>Device Drivers ACPI Support</title>
 <!-- Internal functions only

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
