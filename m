Return-Path: <linux-kernel-owner+w=401wt.eu-S1759865AbXIQJDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759865AbXIQJDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754991AbXIQId4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:56 -0400
Received: from il.qumranet.com ([82.166.9.18]:45323 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781AbXIQIc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:29 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 046/104] KVM: Remove stat_set from debugfs
Date: Mon, 17 Sep 2007 10:31:28 +0200
Message-Id: <1190017948446-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

We shouldn't define stat_set on the debug attributes, since that will
cause silent failure on writing: without a set argument, userspace
will get -EACCESS.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 55639ac..25d76a5 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -3017,11 +3017,7 @@ static u64 stat_get(void *_offset)
 	return total;
 }
 
-static void stat_set(void *offset, u64 val)
-{
-}
-
-DEFINE_SIMPLE_ATTRIBUTE(stat_fops, stat_get, stat_set, "%llu\n");
+DEFINE_SIMPLE_ATTRIBUTE(stat_fops, stat_get, NULL, "%llu\n");
 
 static __init void kvm_init_debug(void)
 {
-- 
1.5.3

