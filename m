Return-Path: <linux-kernel-owner+w=401wt.eu-S1760088AbXFQJwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760088AbXFQJwM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757636AbXFQJo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:44:59 -0400
Received: from il.qumranet.com ([82.166.9.18]:55198 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758863AbXFQJop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:45 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 22/58] KVM: Fix vmx I/O bitmap initialization on highmem systems
Date: Sun, 17 Jun 2007 12:44:03 +0300
Message-Id: <11820734802079-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kunmap() expects a struct page, not a virtual address.  Fixes an oops loading
kvm-intel.ko on i386 with CONFIG_HIGHMEM.

Thanks to Michael Ivanov <deruhu@peterstar.ru> for reporting.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index e39ebe0..34171d9 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -2274,11 +2274,11 @@ static int __init vmx_init(void)
 	iova = kmap(vmx_io_bitmap_a);
 	memset(iova, 0xff, PAGE_SIZE);
 	clear_bit(0x80, iova);
-	kunmap(iova);
+	kunmap(vmx_io_bitmap_a);
 
 	iova = kmap(vmx_io_bitmap_b);
 	memset(iova, 0xff, PAGE_SIZE);
-	kunmap(iova);
+	kunmap(vmx_io_bitmap_b);
 
 	r = kvm_init_arch(&vmx_arch_ops, THIS_MODULE);
 	if (r)
-- 
1.5.0.6

