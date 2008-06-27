Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbYF0F2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbYF0F2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 01:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbYF0F14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 01:27:56 -0400
Received: from ozlabs.org ([203.10.76.45]:49623 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbYF0F14 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 01:27:56 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [RFC 1/3 v2] hvc_console: rework setup to replace irq functions with callbacks
Date: Fri, 27 Jun 2008 15:27:51 +1000
User-Agent: KMail/1.9.9
Cc: Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Yajin <zyj001et@gmail.com>
References: <200806031444.21945.borntraeger@de.ibm.com> <200806201524.08237.borntraeger@de.ibm.com>
In-Reply-To: <200806201524.08237.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806271527.52321.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 June 2008 23:24:08 Christian Borntraeger wrote:
> I also kept hvc_struct defined in hvc_console.h so that hvc_irq.c can
> access the irq_requested element.

Added this fix:

Fix compile of hvc_rtas.c

Moving the struct definition out to the header had bad effect under one
ppc64 config that I tried:

drivers/char/hvc_console.h:59: error: field ‘kref’ has incomplete type

So move the include of kref.h too.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r f382d8f562a8 drivers/char/hvc_console.c
--- a/drivers/char/hvc_console.c	Fri Jun 27 15:17:49 2008 +1000
+++ b/drivers/char/hvc_console.c	Fri Jun 27 15:24:15 2008 +1000
@@ -27,7 +27,6 @@
 #include <linux/init.h>
 #include <linux/kbd_kern.h>
 #include <linux/kernel.h>
-#include <linux/kref.h>
 #include <linux/kthread.h>
 #include <linux/list.h>
 #include <linux/module.h>
diff -r f382d8f562a8 drivers/char/hvc_console.h
--- a/drivers/char/hvc_console.h	Fri Jun 27 15:17:49 2008 +1000
+++ b/drivers/char/hvc_console.h	Fri Jun 27 15:24:15 2008 +1000
@@ -26,6 +26,7 @@
 
 #ifndef HVC_CONSOLE_H
 #define HVC_CONSOLE_H
+#include <linux/kref.h>
 
 /*
  * This is the max number of console adapters that can/will be found as
