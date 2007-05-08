Return-Path: <linux-kernel-owner+w=401wt.eu-S966916AbXEHK5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966916AbXEHK5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 06:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966461AbXEHK5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 06:57:05 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:34513 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966430AbXEHK5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 06:57:02 -0400
Subject: [KJ PATCH] Replacing memset(<addr>,0,PAGE_SIZE) with clear_page()
	in kernel/kexec.c
From: Shani Moideen <shani.moideen@wipro.com>
To: ebiederm@xmission.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@lists.osdl.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Linux COE, Wipro Technolgies
Date: Tue, 08 May 2007 16:20:44 +0530
Message-Id: <1178621444.3598.15.camel@shani-win>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
X-OriginalArrivalTime: 08 May 2007 10:57:00.0907 (UTC) FILETIME=[9AD74BB0:01C7915F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Replacing memset(<addr>,0,PAGE_SIZE) with clear_page() in
kernel/kexec.c 

Signed-off-by: Shani Moideen <shani.moideen@wipro.com>
----

thanks.


diff --git a/kernel/kexec.c b/kernel/kexec.c
index 2a59c8a..1a1afdd 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -787,7 +787,7 @@ static int kimage_load_normal_segment(struct kimage *image,

                ptr = kmap(page);
                /* Start with a clear page */
-               memset(ptr, 0, PAGE_SIZE);
+               clear_page(ptr);
                ptr += maddr & ~PAGE_MASK;
                mchunk = PAGE_SIZE - (maddr & ~PAGE_MASK);
                if (mchunk > mbytes)






-- 
Shani 
