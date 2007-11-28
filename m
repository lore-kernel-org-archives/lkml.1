Return-Path: <linux-kernel-owner+w=401wt.eu-S1758318AbXK1S4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318AbXK1S4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 13:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbXK1S4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 13:56:33 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53453 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751012AbXK1S4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 13:56:32 -0500
Date: Wed, 28 Nov 2007 10:51:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, gimli@dark-green.com,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: 2.6.24-rc3-mm2 Build Failure at imacfb framebuffer driver
Message-Id: <20071128105109.2bf6259f.akpm@linux-foundation.org>
In-Reply-To: <474D6801.7040904@linux.vnet.ibm.com>
References: <20071128034140.648383f0.akpm@linux-foundation.org>
	<474D6801.7040904@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007 18:37:13 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Hi Andrew,
> 
> The kernel build fails, with following error
> 
>   CC      drivers/video/imacfb.o
> drivers/video/imacfb.c: In function ‘imacfb_probe’:
> drivers/video/imacfb.c:238: error: ‘struct screen_info’ has no member named ‘imacpm_seg’
> make[2]: *** [drivers/video/imacfb.o] Error 1
> make[1]: *** [drivers/video] Error 2
> make: *** [drivers] Error 2
> 

That's an easy fix...

From: Andrew Morton <akpm@linux-foundation.org>

Cc: Edgar Hucek <hostmaster@ed-soft.at>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/imacfb.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/video/imacfb.c~a drivers/video/imacfb.c
--- a/drivers/video/imacfb.c~a
+++ a/drivers/video/imacfb.c
@@ -234,10 +234,6 @@ static int __init imacfb_probe(struct pl
 		size_remap = size_total;
 	imacfb_fix.smem_len = size_remap;
 
-#ifndef __i386__
-	screen_info.imacpm_seg = 0;
-#endif
-
 	if (!request_mem_region(imacfb_fix.smem_start, size_total, "imacfb")) {
 		printk(KERN_WARNING
 		       "imacfb: cannot reserve video memory at 0x%lx\n",
_

