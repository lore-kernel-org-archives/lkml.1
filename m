Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865AbYJLJop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbYJLJop (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 05:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbYJLJoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 05:44:37 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:21673 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbYJLJog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 05:44:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vqy5T12TiiOH2C3eYl8R3vatCkLcwoi5nXM34GJn5Yf59EHphS/c0i7dUsxFbl4XvL
         s5/33vWv6io+Rn9ze89D+kBfPG+yIOsfYl0mfR7e8Etze7IXNaKp2Py4ZqTGu5Qh9v3D
         pVtycpIITKyvOhQq84CruHRLQlavsGtcAMeXU=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/7] x86: fix section mismatch warning - reserve_region_with_split
Date: Sun, 12 Oct 2008 11:44:07 +0200
Message-Id: <1223804652-11033-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1223804330-10881-1-git-send-email-marcin.slusarz@gmail.com>
References: <1223804330-10881-1-git-send-email-marcin.slusarz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reserve_region_with_split calls __init function (__reserve_region_with_split)
and is called only from __init function (e820_reserve_resources_late),
so mark it __init

WARNING: vmlinux.o(.text+0x30299): Section mismatch in reference from the function reserve_region_with_split() to the function .init.text:__reserve_region_with_split()
The function reserve_region_with_split() references
the function __init __reserve_region_with_split().
This is often because reserve_region_with_split lacks a __init
annotation or the annotation of __reserve_region_with_split is wrong.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/resource.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 414d6fc..914cea6 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -575,7 +575,7 @@ static void __init __reserve_region_with_split(struct resource *root,
 
 }
 
-void reserve_region_with_split(struct resource *root,
+void __init reserve_region_with_split(struct resource *root,
 		resource_size_t start, resource_size_t end,
 		const char *name)
 {
-- 
1.5.6.4

