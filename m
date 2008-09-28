Return-Path: <linux-kernel-owner+w=401wt.eu-S1753031AbYI1Pxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbYI1Pxe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbYI1Pqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:46:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50860 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbYI1Pp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:45:26 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 11/25] KVM: x86 emulator: fix jmp r/m64 instruction
Date: Sun, 28 Sep 2008 18:44:47 +0300
Message-Id: <1222616701-1206-12-git-send-email-avi@redhat.com>
In-Reply-To: <1222616701-1206-1-git-send-email-avi@redhat.com>
References: <1222616701-1206-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

jmp r/m64 doesn't require the rex.w prefix to indicate the operand size
is 64 bits.  Set the Stack attribute (even though it doesn't involve the
stack, really) to indicate this.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 0630d21..0c120c4 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -288,7 +288,7 @@ static u16 group_table[] = {
 	[Group5*8] =
 	DstMem | SrcNone | ModRM, DstMem | SrcNone | ModRM,
 	SrcMem | ModRM | Stack, 0,
-	SrcMem | ModRM, 0, SrcMem | ModRM | Stack, 0,
+	SrcMem | ModRM | Stack, 0, SrcMem | ModRM | Stack, 0,
 	[Group7*8] =
 	0, 0, ModRM | SrcMem, ModRM | SrcMem,
 	SrcNone | ModRM | DstMem | Mov, 0,
-- 
1.6.0.1

