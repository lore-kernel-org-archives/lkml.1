Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbYJ2GFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbYJ2GFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 02:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbYJ2GF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 02:05:26 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:16417 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbYJ2GFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 02:05:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=FDeC0b9aiOpyfnTlzUZVNpSarv6NE9xd2uiu3yCQSYgiZVyYWkHNE89j2jV+3VlhQk
         9PpL+KHOzi2gH4uI7KkC77dnnufTR+oQMj7vp768zx816jchHnInavYuG0V3YoQIDDBE
         5o6l8KfDnczrqJQhQKv1o5IDVIu/EnMume2BQ=
Subject: [PATCH] x86: two trivial sparse annotations
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 23:05:22 -0700
Message-Id: <1225260322.20276.2.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/vsmp_64.c:87:14: warning: incorrect type in argument 1 (different address spaces)
arch/x86/kernel/vsmp_64.c:87:14:    expected void const volatile [noderef] <asn:2>*addr
arch/x86/kernel/vsmp_64.c:87:14:    got void *[assigned] address
arch/x86/kernel/vsmp_64.c:88:22: warning: incorrect type in argument 1 (different address spaces)
arch/x86/kernel/vsmp_64.c:88:22:    expected void const volatile [noderef] <asn:2>*addr
arch/x86/kernel/vsmp_64.c:88:22:    got void *
arch/x86/kernel/vsmp_64.c:100:23: warning: incorrect type in argument 2 (different address spaces)
arch/x86/kernel/vsmp_64.c:100:23:    expected void volatile [noderef] <asn:2>*addr
arch/x86/kernel/vsmp_64.c:100:23:    got void *
arch/x86/kernel/vsmp_64.c:101:23: warning: incorrect type in argument 1 (different address spaces)
arch/x86/kernel/vsmp_64.c:101:23:    expected void const volatile [noderef] <asn:2>*addr
arch/x86/kernel/vsmp_64.c:101:23:    got void *
arch/x86/mm/gup.c:235:6: warning: incorrect type in argument 1 (different base types)
arch/x86/mm/gup.c:235:6:    expected void const volatile [noderef] <asn:1>*<noident>
arch/x86/mm/gup.c:235:6:    got unsigned long [unsigned] [assigned] start

Impact: fewer sparse warnings, no functional changes

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/vsmp_64.c |    2 +-
 arch/x86/mm/gup.c         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index 7766d36..a688f3b 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -78,7 +78,7 @@ static unsigned __init_or_module vsmp_patch(u8 type, u16 clobbers, void *ibuf,
 
 static void __init set_vsmp_pv_ops(void)
 {
-	void *address;
+	void __iomem *address;
 	unsigned int cap, ctl, cfg;
 
 	/* set vSMP magic bits to indicate vSMP capable kernel */
diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index 4ba373c..be54176 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -233,7 +233,7 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	len = (unsigned long) nr_pages << PAGE_SHIFT;
 	end = start + len;
 	if (unlikely(!access_ok(write ? VERIFY_WRITE : VERIFY_READ,
-					start, len)))
+					(void __user *)start, len)))
 		goto slow_irqon;
 
 	/*
-- 
1.6.0.3.756.gb776d



