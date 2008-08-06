Return-Path: <linux-kernel-owner+w=401wt.eu-S1756655AbYHFNeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbYHFNeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbYHFNd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:33:58 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:9053 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbYHFNd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:33:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=ccQbrbl+UXctLUjM6Am+C6rLzmYRg66bsEEsXQ5frRposgD8mJDOFL3f8vSP7l2bhe
         v+9BUptjM2oLdP9Y+LX6uG/+7CcBuc9i/TseQj6cpOr3zc1XTA8oa1XOgeGH9xlE8zBg
         5WQbq0d2iEtoSgY1XUBhxwiO+Jt1VneRHtfic=
Message-ID: <b9df5fa10808060633j6c1db8e4haa5dc5fd549e7b08@mail.gmail.com>
Date: Wed, 6 Aug 2008 19:33:54 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: mingo@redhat.com
Subject: [PATCH] x86: removes extra assignment from arch/x86/kernel/ldt.c
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello guys, this patch removes an extra assignment from "write_ldt" function.
Thanks.

Signed-off-by : Md.Rakib H. Mullick (rakib.mullick@gmail.com)

--- linux-2.6.27-rc2.orig/arch/x86/kernel/ldt.c	2008-08-06
16:23:53.000000000 +0600
+++ linux-2.6.27-rc2/arch/x86/kernel/ldt.c	2008-08-06 19:18:50.984268144 +0600
@@ -191,11 +191,12 @@ static int write_ldt(void __user *ptr, u
 	error = -EINVAL;
 	if (bytecount != sizeof(ldt_info))
 		goto out;
-	error = -EFAULT;
-	if (copy_from_user(&ldt_info, ptr, sizeof(ldt_info)))
+
+	if (copy_from_user(&ldt_info, ptr, sizeof(ldt_info))) {
+		error = -EFAULT;
 		goto out;
+	}

-	error = -EINVAL;
 	if (ldt_info.entry_number >= LDT_ENTRIES)
 		goto out;
 	if (ldt_info.contents == 3) {
