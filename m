Return-Path: <linux-kernel-owner+w=401wt.eu-S1758279AbXIQIxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279AbXIQIxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbXIQIdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:32 -0400
Received: from il.qumranet.com ([82.166.9.18]:45309 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564AbXIQIci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:38 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Nitin A Kamble <nitin.a.kamble@intel.com>
Subject: [PATCH 102/104] KVM: x86 emulator: fix src, dst value initialization
Date: Mon, 17 Sep 2007 10:32:24 +0200
Message-Id: <11900179492312-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nitin A Kamble <nitin.a.kamble@intel.com>

Some operand fetches are less than the machine word size and can result in
stale bits if used together with operands of different sizes.

Signed-off-by: Nitin A Kamble <nitin.a.kamble@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index cf8db67..7360a71 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -827,6 +827,7 @@ done_prefixes:
 	      srcmem_common:
 		src.type = OP_MEM;
 		src.ptr = (unsigned long *)cr2;
+		src.val = 0;
 		if ((rc = ops->read_emulated((unsigned long)src.ptr,
 					     &src.val, src.bytes, ctxt->vcpu)) != 0)
 			goto done;
@@ -891,6 +892,7 @@ done_prefixes:
 		dst.type = OP_MEM;
 		dst.ptr = (unsigned long *)cr2;
 		dst.bytes = (d & ByteOp) ? 1 : op_bytes;
+		dst.val = 0;
 		if (d & BitOp) {
 			unsigned long mask = ~(dst.bytes * 8 - 1);
 
-- 
1.5.3

