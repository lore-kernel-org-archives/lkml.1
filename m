Return-Path: <linux-kernel-owner+w=401wt.eu-S1752556AbZBNKXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbZBNKXU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 05:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbZBNKXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 05:23:10 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:58673 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbZBNKXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 05:23:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=kmbOhsDeoO/JW3hj3yJ+SgamFuCQcaCKtXqeKn6d2QH/2xJX2ZkRgMeyK8CLxjWmsH
         ujI8TkjLZIIRGNj028w5jW4lEW63vcpFQ1anOJvjoirAS01o294aBd/7gUJ9/Is1xZ04
         4EkA/uugwa7ZtVQn7Cfx1es0C+xRpCQWzVB+g=
Date: Sat, 14 Feb 2009 05:22:55 -0500
From: Alexandre Rostovtsev <tetromino@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-laptop@vger.kernel.org
Subject: [3/3] lenovo-sl-laptop : kconfig etc.
Message-ID: <20090214052255.3a82718d@leftboat.lan>
In-Reply-To: <20090214051902.3927f5e1@leftboat.lan>
References: <20090214051214.359d4fd4@leftboat.lan>
	<20090214051624.0cbc8999@leftboat.lan>
	<20090214051902.3927f5e1@leftboat.lan>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makefiles and kconfigs for the lenovo-sl-laptop driver.

Signed-off-by: Alexandre Rostovtsev <tetromino@gmail.com>

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index ce6badd..a34f9c8 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -95,5 +95,7 @@ source "drivers/staging/epl/Kconfig"
 
 source "drivers/staging/android/Kconfig"
 
+source "drivers/staging/lenovo-sl-laptop/Kconfig"
+
 endif # !STAGING_EXCLUDE_BUILD
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 9ddcc2b..14ce47f 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -30,3 +30,4 @@ obj-$(CONFIG_INPUT_MIMIO)	+= mimio/
 obj-$(CONFIG_TRANZPORT)		+= frontier/
 obj-$(CONFIG_EPL)		+= epl/
 obj-$(CONFIG_ANDROID)		+= android/
+obj-$(CONFIG_LENOVO_SL_LAPTOP)  += lenovo-sl-laptop/
diff --git a/drivers/staging/lenovo-sl-laptop/Kconfig b/drivers/staging/lenovo-sl-laptop/Kconfig
new file mode 100644
index 0000000..88bdeb6
--- /dev/null
+++ b/drivers/staging/lenovo-sl-laptop/Kconfig
@@ -0,0 +1,16 @@
+config LENOVO_SL_LAPTOP
+	tristate "Lenovo SL Series Laptop Extras"
+	depends on X86
+	depends on ACPI
+	depends on INPUT
+	depends on BACKLIGHT_CLASS_DEVICE
+	depends on RFKILL
+	depends on NEW_LEDS
+	---help---
+	  This is a driver for the Lenovo ThinkPad SL series laptops
+	  (SL300/400/500), which are not supported by the thinkpad_acpi
+	  driver. The driver adds support for hotkeys, bluetooth control,
+	  the Lenovo Care LED, and (as an experimental feature) for screen
+	  backlight brightness control. For more information, see
+	  <file:Documentation/laptops/lenovo-sl-laptop.txt>
+
diff --git a/drivers/staging/lenovo-sl-laptop/Makefile b/drivers/staging/lenovo-sl-laptop/Makefile
new file mode 100644
index 0000000..f91b5ab
--- /dev/null
+++ b/drivers/staging/lenovo-sl-laptop/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_LENOVO_SL_LAPTOP)	:= lenovo-sl-laptop.o
