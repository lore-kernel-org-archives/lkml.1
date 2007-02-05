Return-Path: <linux-kernel-owner+w=401wt.eu-S1752675AbXBECll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbXBECll (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 21:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbXBECll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 21:41:41 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:22954 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbXBEClk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 21:41:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=KtXrVxPg6ahONWbciZ70YEbgdRq+APttj0Isl7wQVc/bXk3qrY2qFemaigPCnhpdqsThEEovJmrIUqKOq9u7A2NuKy5Sh/1+kUDCz/dUr4fxum26WmC+YTd+9ztQp/XKUeBVIDxMLcV72yZnF7AQwrbT9MY+BOw7j9sRLuDfy6U=
Date: Mon, 5 Feb 2007 04:41:27 +0200
To: hskinnemoen@atmel.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.20] arch AVR32: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070205024126.GI18118@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205023935.GG18118@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haavard,

A patch to use ARRAY_SIZE macro already defined in linux/kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
Patch isn't compile checked cause I have no AVR32 machine at hand.
Thanks,

diff --git a/arch/avr32/kernel/setup.c b/arch/avr32/kernel/setup.c
index a342116..c6734ae 100644
--- a/arch/avr32/kernel/setup.c
+++ b/arch/avr32/kernel/setup.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/root_dev.h>
 #include <linux/cpu.h>
+#include <linux/kernel.h>
 
 #include <asm/sections.h>
 #include <asm/processor.h>
@@ -174,8 +175,7 @@ static int __init parse_tag_mem_range(struct tag *tag,
 	 * Copy the data so the bootmem init code doesn't need to care
 	 * about it.
 	 */
-	if (mem_range_next_free >=
-	    (sizeof(mem_range_cache) / sizeof(mem_range_cache[0])))
+	if (mem_range_next_free >= ARRAY_SIZE(mem_range_cache))
 		panic("Physical memory map too complex!\n");
 
 	new = &mem_range_cache[mem_range_next_free++];

-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
