Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbYGHXag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbYGHXag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757942AbYGHXPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:15:19 -0400
Received: from gw.goop.org ([64.81.55.164]:51211 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757414AbYGHXOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:45 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 42 of 55] Xen64: HYPERVISOR_set_segment_base() implementation
X-Mercurial-Node: e15c6b05a8ac23b7fb3a6b7caaba024137e08773
Message-Id: <e15c6b05a8ac23b7fb3a.1215554824@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:07:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Habkost <ehabkost@redhat.com>

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/xen/hypercall.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/asm-x86/xen/hypercall.h b/include/asm-x86/xen/hypercall.h
--- a/include/asm-x86/xen/hypercall.h
+++ b/include/asm-x86/xen/hypercall.h
@@ -388,6 +388,14 @@
 	return _hypercall3(int, vcpu_op, cmd, vcpuid, extra_args);
 }
 
+#ifdef CONFIG_X86_64
+static inline int
+HYPERVISOR_set_segment_base(int reg, unsigned long value)
+{
+	return _hypercall2(int, set_segment_base, reg, value);
+}
+#endif
+
 static inline int
 HYPERVISOR_suspend(unsigned long srec)
 {


