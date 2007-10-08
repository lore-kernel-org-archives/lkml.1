Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbXJHLp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbXJHLp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 07:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbXJHLpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 07:45:13 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:65029 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550AbXJHLpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 07:45:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=kEWnl5SFepYggOd786XiOT7KVfpd8QDo5YhT7s7q9GjojAIEARYxHPA3nO/D45aIol/r5dZZFUOg6GnZ8xZ+JDlASVMexl7mv4epkMAzTn6Q1nmel9v2tzEoh92MvqYz2eLLWSByJVImPJGhBRZ4k2iVT8Kzp15mzrPVKQexDYs=
Message-ID: <3d0408630710080445j4dea115emdfe29aac26814536@mail.gmail.com>
Date: Mon, 8 Oct 2007 19:45:08 +0800
From: "Yan Zheng" <yanzheng@21cn.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH]fix VM_CAN_NONLINEAR check in sys_remap_file_pages
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: e7b8addc444d238b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

The test for VM_CAN_NONLINEAR always fails

Signed-off-by: Yan Zheng<yanzheng@21cn.com>
----
diff -ur linux-2.6.23-rc9/mm/fremap.c linux/mm/fremap.c
--- linux-2.6.23-rc9/mm/fremap.c	2007-10-07 15:03:33.000000000 +0800
+++ linux/mm/fremap.c	2007-10-08 19:33:44.000000000 +0800
@@ -160,7 +160,7 @@
 	if (vma->vm_private_data && !(vma->vm_flags & VM_NONLINEAR))
 		goto out;

-	if (!vma->vm_flags & VM_CAN_NONLINEAR)
+	if (!(vma->vm_flags & VM_CAN_NONLINEAR))
 		goto out;

 	if (end <= start || start < vma->vm_start || end > vma->vm_end)
