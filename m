Return-Path: <linux-kernel-owner+w=401wt.eu-S1030461AbXCCVmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030461AbXCCVmO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 16:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030487AbXCCVmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 16:42:14 -0500
Received: from wr-out-0506.google.com ([64.233.184.233]:49433 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030461AbXCCVlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 16:41:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=rUTIJbN0lh26mJkf1GVUbuRTKUoMwUtZFRUuZy51gwX4KmEJKdJnT4UgFKPIAgkTXg93+t9XJqvJpbh3Esr2BUZRnm33J6r6gPn4vh9M6+F32yyJsW9IjghKYnBN8l7xFQ1aY/9l9KJbI6yPLKp1BSQXZdmFkuq3sIt2aAdm11Q=
Message-ID: <3d8471ca0703031341p374a3c3bs3920ef2b9c3644f9@mail.gmail.com>
Date: Sat, 3 Mar 2007 22:41:45 +0100
From: "Guillaume Chazarain" <guichaz@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: [3/3] Possible bugfix: make dmi_mark_tsc_unstable() call mark_tsc_unstable()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Let the clocksource know the TSC is disabled.

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
---

diff -r a9fe2d530385 arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c	Sat Mar 03 22:13:29 2007 +0100
+++ b/arch/i386/kernel/tsc.c	Sat Mar 03 22:14:27 2007 +0100
@@ -317,7 +317,7 @@ static int __init dmi_mark_tsc_unstable(
 {
 	printk(KERN_NOTICE "%s detected: marking TSC unstable.\n",
 		       d->ident);
-	tsc_disable = 1;
+	mark_tsc_unstable();
 	return 0;
 }



-- 
Guillaume
