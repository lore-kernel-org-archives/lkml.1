Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbYHUMuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbYHUMuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 08:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753899AbYHUMub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 08:50:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:46361 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832AbYHUMua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 08:50:30 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, linuxppc-dev@ozlabs.org
Subject: [PATCH] math-emu: Fix compiler warnings
Date: Thu, 21 Aug 2008 07:50:20 -0500
Message-Id: <1219323021-7273-1-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix warnings of the form:
arch/powerpc/math-emu/fsubs.c:15: warning: 'R_f1' may be used uninitialized in this function
arch/powerpc/math-emu/fsubs.c:15: warning: 'R_f0' may be used uninitialized in this function

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---

I intend these patches to go via the powerpc.git tree if no one has issues.

- k

 include/math-emu/op-2.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/math-emu/op-2.h b/include/math-emu/op-2.h
index e193fb0..4f26ecc 100644
--- a/include/math-emu/op-2.h
+++ b/include/math-emu/op-2.h
@@ -25,7 +25,7 @@
 #ifndef __MATH_EMU_OP_2_H__
 #define __MATH_EMU_OP_2_H__
 
-#define _FP_FRAC_DECL_2(X)	_FP_W_TYPE X##_f0, X##_f1
+#define _FP_FRAC_DECL_2(X)	_FP_W_TYPE X##_f0 = 0, X##_f1 = 0
 #define _FP_FRAC_COPY_2(D,S)	(D##_f0 = S##_f0, D##_f1 = S##_f1)
 #define _FP_FRAC_SET_2(X,I)	__FP_FRAC_SET_2(X, I)
 #define _FP_FRAC_HIGH_2(X)	(X##_f1)
-- 
1.5.5.1

