Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbYCaOkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbYCaOkw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbYCaOhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:37:37 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51314
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbYCaOhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:37:32 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/40] KVM: Limit vcpu mmap size to one page on non-x86
Date: Mon, 31 Mar 2008 17:36:56 +0300
Message-Id: <1206974244-9716-13-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1206974244-9716-1-git-send-email-avi@qumranet.com>
References: <1206974244-9716-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second page is only needed on archs that support pio.

Noted by Carsten Otte.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 virt/kvm/kvm_main.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 121e65c..7972e3a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1061,7 +1061,10 @@ static long kvm_dev_ioctl(struct file *filp,
 		r = -EINVAL;
 		if (arg)
 			goto out;
-		r = 2 * PAGE_SIZE;
+		r = PAGE_SIZE;     /* struct kvm_run */
+#ifdef CONFIG_X86
+		r += PAGE_SIZE;    /* pio data page */
+#endif
 		break;
 	default:
 		return kvm_arch_dev_ioctl(filp, ioctl, arg);
-- 
1.5.4.5

