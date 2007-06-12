Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbXFLCxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbXFLCxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 22:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbXFLCww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 22:52:52 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:34330 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbXFLCwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 22:52:51 -0400
Subject: [KJ PATCH] Replacing memcpy(dest,src,PAGE_SIZE) with
	copy_page(dest,src) in arch/i386/kernel/machine_kexec.c
From: Shani Moideen <shani.moideen@wipro.com>
To: ebiederm@xmission.com
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       kernel-janitors@lists.osdl.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Linux COE, Wipro Technolgies
Date: Tue, 12 Jun 2007 08:15:41 +0530
Message-Id: <1181616342.2282.8.camel@shani-win>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
X-OriginalArrivalTime: 12 Jun 2007 02:52:49.0656 (UTC) FILETIME=[C3676F80:01C7AC9C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Replacing memcpy(dest,src,PAGE_SIZE) with copy_page(dest,src) in arch/i386/kernel/machine_kexec.c.

Signed-off-by: Shani Moideen <shani.moideen@wipro.com>
----

diff --git a/arch/i386/kernel/machine_kexec.c b/arch/i386/kernel/machine_kexec.c
index 91966ba..ce79a44 100644
--- a/arch/i386/kernel/machine_kexec.c
+++ b/arch/i386/kernel/machine_kexec.c
@@ -110,7 +110,7 @@ NORET_TYPE void machine_kexec(struct kimage *image)
 	local_irq_disable();
 
 	control_page = page_address(image->control_code_page);
-	memcpy(control_page, relocate_kernel, PAGE_SIZE);
+	copy_page(control_page, relocate_kernel);
 
 	page_list[PA_CONTROL_PAGE] = __pa(control_page);
 	page_list[VA_CONTROL_PAGE] = (unsigned long)relocate_kernel;

-- 
Shani 
