Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbZLILxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbZLILxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 06:53:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755299AbZLILxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 06:53:35 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:48897 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755296AbZLILxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 06:53:35 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] asm-generic/gpio.h: add some forward decls of the device struct
Date: Wed,  9 Dec 2009 06:53:39 -0500
Message-Id: <1260359619-15618-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the recent commit a4177ee7f, attempting to include asm-generic/gpio.h
in otherwise "slim" code results in ugly warnings like so:

  CC      arch/blackfin/kernel/bfin_gpio.o
In file included from arch/blackfin/include/asm/gpio.h:278,
                 from arch/blackfin/kernel/bfin_gpio.c:15:
include/asm-generic/gpio.h:193: warning:
‘struct device’ declared inside parameter list
its scope is only this definition or declaration, which is probably not what you want

So add simple C forward decls of the struct device to avoid these.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/asm-generic/gpio.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 66d6106..204bed3 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -28,6 +28,7 @@ static inline int gpio_is_valid(int number)
 	return ((unsigned)number) < ARCH_NR_GPIOS;
 }
 
+struct device;
 struct seq_file;
 struct module;
 
@@ -181,6 +182,8 @@ static inline void gpio_set_value_cansleep(unsigned gpio, int value)
 
 #ifndef CONFIG_GPIO_SYSFS
 
+struct device;
+
 /* sysfs support is only available with gpiolib, where it's optional */
 
 static inline int gpio_export(unsigned gpio, bool direction_may_change)
-- 
1.6.5.5

