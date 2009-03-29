Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbZC2VWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbZC2VWh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 17:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755977AbZC2VV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 17:21:57 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:62907 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbZC2VVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 17:21:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WdYzWlJPE9PvzE9ciIJTp5Ik+1jQZjEA0Gl9SYHe8LYtcqDDwSt/K0pKhA4rM6+yP5
         D1E2Dect0x5ZbpkW0pLmUfhPtjL/FjpUfN3Vt5+03z49CBWYCslYx5s/Zl1b8zLE0xzv
         T2tw9h8X+nFJ9+47l+OThBCfEJ3Nabzy7G+yA=
From: Joe Damato <ice799@gmail.com>
To: linux-x86_64@vger.kernel.org, w@1wt.eu, mingo@elte.hu, hpa@zytor.com,
       jeremy@goop.org, linux-newbie@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Joe Damato <ice799@gmail.com>
Subject: [PATCH 1/2] x86: Add getter/setter static inlines for x86 descriptors
Date: Sun, 29 Mar 2009 14:21:41 -0700
Message-Id: <76c37743d20e5737eadc747cbdddbc2beb11f074.1238361501.git.ice799@gmail.com>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <cover.1238361501.git.ice799@gmail.com>
References: <cover.1238361501.git.ice799@gmail.com>
In-Reply-To: <cover.1238361501.git.ice799@gmail.com>
References: <cover.1238361501.git.ice799@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Static inline getters/setters have been provided to encourage consumers not to touch the internals of 32bit x86 descriptors directly.

Signed-off-by: Joe Damato <ice799@gmail.com>
---
 arch/x86/include/asm/desc.h |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index dc27705..c62cf93 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -44,6 +44,26 @@ static inline struct desc_struct *get_cpu_gdt_table(unsigned int cpu)
 	return per_cpu(gdt_page, cpu).gdt;
 }
 
+static inline void desc_set_lo(struct desc_struct *d, unsigned int lo)
+{
+	d->a = lo;
+}
+
+static inline void desc_set_hi(struct desc_struct *d, unsigned int hi)
+{
+	d->b = hi;
+}
+
+static inline unsigned int desc_get_lo(const struct desc_struct *d)
+{
+	return d->a;
+}
+
+static inline unsigned int desc_get_hi(const struct desc_struct *d)
+{
+	return d->b;
+}
+
 #ifdef CONFIG_X86_64
 
 static inline void pack_gate(gate_desc *gate, unsigned type, unsigned long func,
-- 
1.6.2

