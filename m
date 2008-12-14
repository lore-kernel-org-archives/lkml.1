Return-Path: <linux-kernel-owner+w=401wt.eu-S1757074AbYLNIPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbYLNIPx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbYLNIHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:07:47 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59925 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323AbYLNIHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:16 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Amit Shah <amit.shah@redhat.com>
Subject: [PATCH 31/36] KVM: x86 emulator: Fix handling of VMMCALL instruction
Date: Sun, 14 Dec 2008 10:07:04 +0200
Message-Id: <1229242029-13410-32-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Shah <amit.shah@redhat.com>

The VMMCALL instruction doesn't get recognised and isn't processed
by the emulator.

This is seen on an Intel host that tries to execute the VMMCALL
instruction after a guest live migrates from an AMD host.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 219dc31..d174db7 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -311,7 +311,7 @@ static u32 group_table[] = {
 
 static u32 group2_table[] = {
 	[Group7*8] =
-	SrcNone | ModRM, 0, 0, 0,
+	SrcNone | ModRM, 0, 0, SrcNone | ModRM,
 	SrcNone | ModRM | DstMem | Mov, 0,
 	SrcMem16 | ModRM | Mov, 0,
 };
-- 
1.6.0.3

