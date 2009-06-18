Return-Path: <linux-kernel-owner+w=401wt.eu-S1761391AbZFRLkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761391AbZFRLkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 07:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbZFRLkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 07:40:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:39290 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbZFRLkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 07:40:00 -0400
Subject: [PATCH -tip] x86: oprofile/op_model_amd.c set return values for
 op_amd_handle_ibs()
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Robert Richter <robert.richter@amd.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Jun 2009 17:09:27 +0530
Message-Id: <1245325167.7189.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


op_amd_handle_ibs() should return 0 when IBS is not present or not defined.

Fix compilation warning:
 CC [M]  arch/x86/oprofile/op_model_amd.o
 arch/x86/oprofile/op_model_amd.c: In function ‘op_amd_handle_ibs’:
 arch/x86/oprofile/op_model_amd.c:217: warning: no return statement in function returning non-void

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/oprofile/op_model_amd.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index cc93046..e95268e 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -132,7 +132,7 @@ op_amd_handle_ibs(struct pt_regs * const regs,
 	struct op_entry entry;
 
 	if (!has_ibs)
-		return 1;
+		return 0;
 
 	if (ibs_config.fetch_enabled) {
 		rdmsrl(MSR_AMD64_IBSFETCHCTL, ctl);
@@ -214,7 +214,10 @@ static void op_amd_stop_ibs(void)
 #else
 
 static inline int op_amd_handle_ibs(struct pt_regs * const regs,
-				    struct op_msrs const * const msrs) { }
+				    struct op_msrs const * const msrs)
+{
+	return 0;
+}
 static inline void op_amd_start_ibs(void) { }
 static inline void op_amd_stop_ibs(void) { }
 
-- 
1.6.0.6



