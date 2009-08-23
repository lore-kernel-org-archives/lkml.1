Return-Path: <linux-kernel-owner+w=401wt.eu-S933871AbZHWMG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933871AbZHWMG4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 08:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933781AbZHWMGC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 08:06:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933519AbZHWL4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:48 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/46] KVM: Fix apic_mmio_write return for unaligned write
Date: Sun, 23 Aug 2009 14:56:07 +0300
Message-Id: <1251028605-31977-9-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

Some in-famous OS do unaligned writing for APIC MMIO, and the return value
has been missed in recent change, then the OS hangs.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/lapic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index dc6bec2..31f1d1c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -828,7 +828,7 @@ static int apic_mmio_write(struct kvm_io_device *this,
 	if (len != 4 || (offset & 0xf)) {
 		/* Don't shout loud, $infamous_os would cause only noise. */
 		apic_debug("apic write: bad size=%d %lx\n", len, (long)address);
-		return;
+		return 0;
 	}
 
 	val = *(u32*)data;
-- 
1.6.4.1

