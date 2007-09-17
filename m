Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbXIQImz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbXIQImz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbXIQIcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:53 -0400
Received: from il.qumranet.com ([82.166.9.18]:45291 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905AbXIQIc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:29 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH 051/104] KVM: Remove useless assignment
Date: Mon, 17 Sep 2007 10:31:33 +0200
Message-Id: <11900179482643-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Vivier <Laurent.Vivier@bull.net>

Line 1809 of kvm_main.c is useless, value is overwritten in line 1815:

1809         now = min(count, PAGE_SIZE / size);
1810
1811         if (!down)
1812                 in_page = PAGE_SIZE - offset_in_page(address);
1813         else
1814                 in_page = offset_in_page(address) + size;
1815         now = min(count, (unsigned long)in_page / size);
1816         if (!now) {

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 1b86ab0..62adaee 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1776,8 +1776,6 @@ int kvm_setup_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 		return 1;
 	}
 
-	now = min(count, PAGE_SIZE / size);
-
 	if (!down)
 		in_page = PAGE_SIZE - offset_in_page(address);
 	else
-- 
1.5.3

