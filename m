Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbYK0Vbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbYK0Vbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 16:31:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYK0VbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 16:31:24 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:50211 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbYK0VbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 16:31:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OPVlBuJaTd4sKG+OyRLfiOdMMfOg3lcoyhOoN0+bmbszQgK8DoTu43C2xE1zn61Ilx
         ILN366+o1GzJbVpUc/plKduxX3IzLYTRoTxZGWcl7rpS0hJnYrqb1PVIWMBnHdjjTpQy
         uGIqGeD6EyBir7UdwRFGRj2z5y2eGukiBQTBg=
Message-ID: <2375c9f90811271331q40adeef6nf1f3d27f3a92a444@mail.gmail.com>
Date: Thu, 27 Nov 2008 21:31:22 +0000
From: "=?UTF-8?Q?Am=C3=A9rico_Wang?=" <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] uml: fix the highmem build error
Cc: "Andrew Morton" <akpm@osdl.org>, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net,
       "Al Viro" <viro@zeniv.linux.org.uk>
In-Reply-To: <20081127181228.GA4417@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <20081127181228.GA4417@hack.voiplan.pt>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id mARLVbdq002629

On Thu, Nov 27, 2008 at 6:12 PM, AmÃ©rico Wang <xiyou.wangcong@gmail.com> wrote:>> This patch fixes this error:>> arch/um/kernel/mem.c: In function 'init_highmem':> arch/um/kernel/mem.c:177: error: 'pkmap_page_table' undeclared (first> use in this function)> arch/um/kernel/mem.c:177: error: (Each undeclared identifier is> reported only once> arch/um/kernel/mem.c:177: error: for each function it appears in.)>> Compile and run tested.>
Ignore the above one, below is the updated version.
------->
This patch fixes this error:
arch/um/kernel/mem.c: In function 'init_highmem':arch/um/kernel/mem.c:177: error: 'pkmap_page_table' undeclared (firstuse in this function)arch/um/kernel/mem.c:177: error: (Each undeclared identifier isreported only oncearch/um/kernel/mem.c:177: error: for each function it appears in.)

Signed-off-by: WANG Cong <wangcong@zeuux.org>Cc: Jeff Dike <jdike@addtoit.com>Cc: Al Viro <viro@zeniv.linux.org.uk>
diff --git a/arch/um/include/asm/fixmap.h b/arch/um/include/asm/fixmap.hindex 69c0252..a8e29e5 100644--- a/arch/um/include/asm/fixmap.h+++ b/arch/um/include/asm/fixmap.h@@ -41,6 +41,12 @@ enum fixed_addresses { 	__end_of_fixed_addresses };
+#ifdef CONFIG_HIGHMEM+extern pte_t *pkmap_page_table;+extern pte_t *kmap_pte;+extern pgprot_t kmap_prot;+#endif+ extern void __set_fixmap (enum fixed_addresses idx, 			  unsigned long phys, pgprot_t flags);
diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.cindex bcc079c..884f9e2 100644--- a/arch/x86/mm/highmem_32.c+++ b/arch/x86/mm/highmem_32.c@@ -1,3 +1,4 @@+#include <asm/fixmap.h> #include <linux/highmem.h> #include <linux/module.h>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
