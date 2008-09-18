Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbYIRNY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbYIRNY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 09:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbYIRNYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 09:24:50 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:52139 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753611AbYIRNYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 09:24:49 -0400
Subject: kernel.h: add ARRAY_AND_SIZE() macro to complement ARRAY_SIZE().
Message-Id: <20080918132447.516309749@fluff.org.uk>
User-Agent: quilt/0.46-1
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Cc: Ben Dooks <ben-linux@fluff.org>
Content-Disposition: inline; filename=simtec/simtec-kernel-array-and-size.patch
Date: Thu, 18 Sep 2008 14:24:47 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the ARRAY_AND_SIZE() macro from arch/arm/mach-pxa/generic.h
to a more useful position in include/linux/kernel.h. This macro
is very useful to registration functions that take an array and
the number of array elements in it as consecutive arguments.

The macro also should ensure that mistakes where the wrong array
is used to the ARRAY_SIZE() macro is passed. It also makes it
easier to avoid wrapping registration function arguments.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.27-rc6-quilt4/arch/arm/mach-pxa/generic.h
===================================================================
--- linux-2.6.27-rc6-quilt4.orig/arch/arm/mach-pxa/generic.h	2008-09-18 14:16:47.000000000 +0100
+++ linux-2.6.27-rc6-quilt4/arch/arm/mach-pxa/generic.h	2008-09-18 14:16:52.000000000 +0100
@@ -29,8 +29,6 @@ extern int pxa_last_gpio;
 	mi->bank[__nr].size = (__size), \
 	mi->bank[__nr].node = (((unsigned)(__start) - PHYS_OFFSET) >> 27)
 
-#define ARRAY_AND_SIZE(x)	(x), ARRAY_SIZE(x)
-
 #ifdef CONFIG_PXA25x
 extern unsigned pxa25x_get_clk_frequency_khz(int);
 extern unsigned pxa25x_get_memclk_frequency_10khz(void);
Index: linux-2.6.27-rc6-quilt4/include/linux/kernel.h
===================================================================
--- linux-2.6.27-rc6-quilt4.orig/include/linux/kernel.h	2008-09-18 14:16:06.000000000 +0100
+++ linux-2.6.27-rc6-quilt4/include/linux/kernel.h	2008-09-18 14:16:31.000000000 +0100
@@ -43,6 +43,7 @@ extern const char linux_proc_banner[];
 #define IS_ALIGNED(x, a)		(((x) & ((typeof(x))(a) - 1)) == 0)
 
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
+#define ARRAY_AND_SIZE(arr) (arr), ARRAY_SIZE(arr)
 
 #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
