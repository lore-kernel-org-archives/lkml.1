Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab0BFNeh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 08:34:37 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:50313 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab0BFNef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 08:34:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=aHP/5c92XzaZTgZ2w8OiuTCvvMjoSfn66sgAdZ1W4Vdv+iiubn1aydAoGDDu37Devx
         LRVnAX6Pq+9XWDJg6IqSPOV4X+fmHImpofLOklOf0BPdh2jsQsYZt2DgVf0WQvdy81aE
         RhiN69kU6h31R9Uwd8rCyUewUbz0TyfHMS+4k=
Date: Sat, 6 Feb 2010 21:34:25 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/2] printk delay for each line break instead of callback
Message-ID: <20100206133425.GA2562@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk delay for every callback does not make sense, change to delay every line

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---

 kernel/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/kernel/printk.c	2010-02-02 13:38:47.646659531 +0800
+++ linux-2.6/kernel/printk.c	2010-02-02 13:39:19.446657319 +0800
@@ -678,7 +678,6 @@ asmlinkage int vprintk(const char *fmt, 
 	char *p;
 
 	boot_delay_msec();
-	printk_delay();
 
 	preempt_disable();
 	/* This stops the holder of console_sem just where we want him */
@@ -746,6 +745,7 @@ asmlinkage int vprintk(const char *fmt, 
 	 */
 	for ( ; *p; p++) {
 		if (new_text_line) {
+			printk_delay();
 			/* Always output the token */
 			emit_log_char('<');
 			emit_log_char(current_log_level + '0');
