Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab0BHVK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 16:10:56 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:62685 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab0BHVKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 16:10:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=qB1LAdtkjfXOdb8552cOn7WrIWE+IAF/qHShQTcj5u20CcGlrUwkMDBlBrsRnN6yIU
         dY50g+crzTuLQ3EE6PQBizap/7hS67NXP/4cnhBnJh3Eaapnya+XlmpaSPdgJNHrqUiL
         Tq9mp5F3e15N8WkCzUIdwwm06L/s/HTDq1s3Q=
Message-ID: <4B707F6E.2090108@gmail.com>
Date: Mon, 08 Feb 2010 22:17:34 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: liqin.chen@sunplusct.com, arnd@arndb.de,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] score: Fix dereference of NULL pointer in local_flush_tlb_page()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't dereference vma if it's NULL.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/arch/score/mm/tlb-score.c b/arch/score/mm/tlb-score.c
index 4fa5aa5..6fdb100 100644
--- a/arch/score/mm/tlb-score.c
+++ b/arch/score/mm/tlb-score.c
@@ -158,7 +158,7 @@ void local_flush_tlb_kernel_range(unsigned long start, unsigned long end)
 
 void local_flush_tlb_page(struct vm_area_struct *vma, unsigned long page)
 {
-	if (!vma || vma->vm_mm->context != 0) {
+	if (vma && vma->vm_mm->context != 0) {
 		unsigned long flags;
 		int oldpid, newpid, idx;
 		unsigned long vma_ASID = vma->vm_mm->context;
