Return-Path: <linux-kernel-owner+w=401wt.eu-S1760620AbYFZMq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760620AbYFZMq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755118AbYFZMaC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:30:02 -0400
Received: from il.qumranet.com ([212.179.150.194]:32349 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbYFZM2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:36 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Aurelien Jarno <aurelien@aurel32.net>
Subject: [PATCH 10/50] KVM: PIT: support mode 3
Date: Thu, 26 Jun 2008 15:27:52 +0300
Message-Id: <1214483312-9265-11-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aurelien Jarno <aurelien@aurel32.net>

The in-kernel PIT emulation ignores pending timers if operating
under mode 3, which for example Hurd uses.

This mode should output a square wave, high for (N+1)/2 counts and low
for (N-1)/2 counts. As we only care about the resulting interrupts, the
period is N, and mode 3 is the same as mode 2 with regard to
interrupts.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/i8254.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 735ec9a..60074dc 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -308,6 +308,7 @@ static void pit_load_count(struct kvm *kvm, int channel, u32 val)
 		create_pit_timer(&ps->pit_timer, val, 0);
 		break;
 	case 2:
+	case 3:
 		create_pit_timer(&ps->pit_timer, val, 1);
 		break;
 	default:
-- 
1.5.6

