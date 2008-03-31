Return-Path: <linux-kernel-owner+w=401wt.eu-S1760166AbYCaOsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760166AbYCaOsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbYCaOhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:37:53 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51329
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbYCaOhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:37:36 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH 34/40] KVM: x86 emulator: add ad_mask static inline
Date: Mon, 31 Mar 2008 17:37:18 +0300
Message-Id: <1206974244-9716-35-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1206974244-9716-1-git-send-email-avi@qumranet.com>
References: <1206974244-9716-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>

Replaces open-coded mask calculation in macros.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 22900f7..f6f6544 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -480,10 +480,15 @@ static u16 group2_table[] = {
 	(_type)_x;							\
 })
 
+static inline unsigned long ad_mask(struct decode_cache *c)
+{
+	return (1UL << (c->ad_bytes << 3)) - 1;
+}
+
 /* Access/update address held in a register, based on addressing mode. */
 #define address_mask(reg)						\
 	((c->ad_bytes == sizeof(unsigned long)) ? 			\
-		(reg) :	((reg) & ((1UL << (c->ad_bytes << 3)) - 1)))
+		(reg) :	((reg) & ad_mask(c)))
 #define register_address(base, reg)                                     \
 	((base) + address_mask(reg))
 #define register_address_increment(reg, inc)                            \
@@ -494,9 +499,9 @@ static u16 group2_table[] = {
 			(reg) += _inc;					\
 		else							\
 			(reg) = ((reg) & 				\
-				 ~((1UL << (c->ad_bytes << 3)) - 1)) |	\
+				 ~ad_mask(c)) |	\
 				(((reg) + _inc) &			\
-				 ((1UL << (c->ad_bytes << 3)) - 1));	\
+				 ad_mask(c));	\
 	} while (0)
 
 #define JMP_REL(rel) 							\
-- 
1.5.4.5

