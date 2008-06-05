Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbYFENo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbYFENo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 09:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbYFENoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 09:44:18 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:16893 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbYFENoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 09:44:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=utE+lyRwwHj+Wq2BUI5rHwZTcbT8Jz3gvoGbFfgGUezIiSaKauldJkG8rz2dlj4n5I
         J//iOjv6xGyXDPOMJL6SNWZBC5md6xUico0PpvjXqYv9sb6zbBAf10AS8ev4UGbCdNWj
         cE/kbTtfxbTDeG1NZ5LZOAr8tDMJQlN1yb9xk=
Message-ID: <ea11fea30806050644o216c798pbe88d269a63f64f2@mail.gmail.com>
Date: Thu, 5 Jun 2008 19:14:15 +0530
From: "Manish Katiyar" <mkatiyar@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Subject: [PATCH] : Fix unused variable 'loops' warning in arch/x86/boot/a20.c
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patch fixes the below warning message :
arch/x86/boot/a20.c:118: warning: unused variable 'loops'

=================================================

Signed-off-by : Manish Katiyar <mkatiyar@gmail.com>

diff --git a/arch/x86/boot/a20.c b/arch/x86/boot/a20.c
index 90943f8..d9f13bf 100644
--- a/arch/x86/boot/a20.c
+++ b/arch/x86/boot/a20.c
@@ -115,8 +115,6 @@ static void enable_a20_fast(void)

 int enable_a20(void)
 {
-       int loops = A20_ENABLE_LOOPS;
-
 #if defined(CONFIG_X86_ELAN)
        /* Elan croaks if we try to touch the KBC */
        enable_a20_fast();
@@ -128,6 +126,7 @@ int enable_a20(void)
        enable_a20_kbc();
        return 0;
 #else
+       int loops = A20_ENABLE_LOOPS;
        while (loops--) {
                /* First, check to see if A20 is already enabled
                   (legacy free, etc.) */


================================================

-- 
Thanks & Regards,
********************************************
Manish Katiyar ( http://mkatiyar.googlepages.com )
3rd Floor, Fair Winds Block
EGL Software Park
Off Intermediate Ring Road
Bangalore 560071, India
***********************************************
