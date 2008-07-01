Return-Path: <linux-kernel-owner+w=401wt.eu-S1758913AbYGAWi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbYGAWi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 18:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762027AbYGAWhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 18:37:50 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:32611 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761986AbYGAWht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 18:37:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=03R2FS6R9xlKeyK9iqwBxCwfYZhcadOc9E2jcc61FWd/QEREgUO9hicdRGNbQw9tdt2/E49zL7zHuR7Bu4WOi5ss/zCL5uSyN7xlFHFaPCIqmNZ+Mb0QZyAhBsmYD8IeRE1mR6jdip2Em8shdacfxL8HyPQNbOYVloFKFaP1vFQ=  ;
X-YMail-OSG: 8oiFdfgVM1kZE3kZAIpiq9JJcgikBn5yh3V6BiL7GLLZ6xP9X1E9SzA4HTiq6FfOhL4X2ws72iPkVkOHXrm2RB133xwADXcQOvyMyuRUjI_qO24DWO6XJ83CpmpIUuU8spo-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Domenico Andreoli <cavokz@gmail.com>
Subject: Re: [PATCH] Add btgpio driver
Date: Tue, 1 Jul 2008 15:37:46 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel <linux-kernel@vger.kernel.org>
References: <200807010206.38714.mb@bu3sch.de> <20080701010414.GA5279@ska.dandreoli.com> <20080701220601.GA31029@ska.dandreoli.com>
In-Reply-To: <20080701220601.GA31029@ska.dandreoli.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807011537.46297.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 July 2008, Domenico Andreoli wrote:
> 
> > How one is supposed to test this driver? I am unable to switch on
> > the GPIO lib support in my config. I tried also allyesconfig but no
> > trace of gpio lib stuff.
> 
> Really, GPIO menu is no present anywhere. While searching for GPIO
> finds stuff, I am unable to locate and select it. I am using 2.6.26-rc8

Appended is what I use on x86 PCs.  It's not quite suitable for merge
as-is since there's some x86 system with a nonstandard setup.

- Dave

====== CUT HERE
DEBUG ONLY -- make X86_PC use gpiolib.

It's not clear to me how the various x86-ish platforms should
be made to work here, since there seems to be no convention
that each platform type has its own <asm/arch/...> subdir.

---
 arch/x86/Kconfig       |    2 ++
 include/asm-x86/gpio.h |   20 +++++++++++++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

--- a/arch/x86/Kconfig	2008-06-30 16:44:30.000000000 -0700
+++ b/arch/x86/Kconfig	2008-06-30 21:37:08.000000000 -0700
@@ -236,6 +236,8 @@ choice
 
 config X86_PC
 	bool "PC-compatible"
+	select GENERIC_GPIO
+	select HAVE_GPIO_LIB
 	help
 	  Choose this option if your computer is a standard PC or compatible.
 
--- a/include/asm-x86/gpio.h	2008-06-30 16:44:30.000000000 -0700
+++ b/include/asm-x86/gpio.h	2008-06-30 21:37:08.000000000 -0700
@@ -1,6 +1,24 @@
 #ifndef _ASM_I386_GPIO_H
 #define _ASM_I386_GPIO_H
 
-#include <gpio.h>
+// #include <gpio.h>
+
+#include <linux/errno.h>
+#include <asm-generic/gpio.h>           /* cansleep wrappers */
+
+#define gpio_get_value	__gpio_get_value
+#define gpio_set_value	__gpio_set_value
+#define gpio_cansleep	__gpio_cansleep
+
+static inline int gpio_to_irq(unsigned gpio)
+{
+	return -ENOSYS;
+}
+
+static inline int irq_to_gpio(unsigned irq)
+{
+	return -EINVAL;
+}
+
 
 #endif /* _ASM_I386_GPIO_H */
