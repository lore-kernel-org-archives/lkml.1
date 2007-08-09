Return-Path: <linux-kernel-owner+w=401wt.eu-S966184AbXHIPIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966184AbXHIPIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 11:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935348AbXHIPI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 11:08:28 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36822 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S940487AbXHIPI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 11:08:27 -0400
Message-ID: <46BB2DBB.7050404@sgi.com>
Date: Thu, 09 Aug 2007 17:07:39 +0200
From: Jes Sorensen <jes@sgi.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, lguest <lguest@ozlabs.org>
Subject: [patch] lguest files should explicitly include asm/paravirt.h
Content-Type: multipart/mixed;
 boundary="------------030904080000030604070900"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030904080000030604070900
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

This one makes a few lguest related files that rely on paravirt_ops
include paravirt.h explicitly. Should be harmless :)

Jes


--------------030904080000030604070900
Content-Type: text/plain;
 name="paravirt-include.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="paravirt-include.diff"

Files using bits from paravirt.h should explicitly include it rather than
relying on it being pulled in by something else.

Signed-off-by: Jes Sorensen <jes@sgi.com>

---
 drivers/char/hvc_lguest.c   |    1 +
 drivers/lguest/lguest_bus.c |    1 +
 2 files changed, 2 insertions(+)

Index: linux-2.6-lguest/drivers/char/hvc_lguest.c
===================================================================
--- linux-2.6-lguest.orig/drivers/char/hvc_lguest.c
+++ linux-2.6-lguest/drivers/char/hvc_lguest.c
@@ -35,6 +35,7 @@
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/lguest_bus.h>
+#include <asm/paravirt.h>
 #include "hvc_console.h"
 
 /*D:340 This is our single console input buffer, with associated "struct
Index: linux-2.6-lguest/drivers/lguest/lguest_bus.c
===================================================================
--- linux-2.6-lguest.orig/drivers/lguest/lguest_bus.c
+++ linux-2.6-lguest/drivers/lguest/lguest_bus.c
@@ -5,6 +5,7 @@
 #include <linux/bootmem.h>
 #include <linux/lguest_bus.h>
 #include <asm/io.h>
+#include <asm/paravirt.h>
 
 static ssize_t type_show(struct device *_dev,
                          struct device_attribute *attr, char *buf)

--------------030904080000030604070900--
