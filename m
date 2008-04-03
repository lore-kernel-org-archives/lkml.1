Return-Path: <linux-kernel-owner+w=401wt.eu-S1757352AbYDCWrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbYDCWrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 18:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbYDCWrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 18:47:13 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:46167 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbYDCWrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 18:47:12 -0400
Date: Thu, 3 Apr 2008 23:48:29 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Ingo Molnar <mingo@elte.hu>
cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] x86: MPSC should use P6 NOPs
Message-ID: <Pine.LNX.4.64.0804032344260.28157@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've now noticed that the machine I call MPENTIUM4 for 32-bit kernels
is called MPSC for 64-bit kernels, and in that case it still doesn't
get the P6 NOPs it ought to.  hpa explains that MK8 should still be
excluded, so it's just a matter of including MPSC along with MPENTIUM4.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 arch/x86/Kconfig.cpu |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.25-rc8/arch/x86/Kconfig.cpu	2008-03-05 10:47:37.000000000 +0000
+++ linux/arch/x86/Kconfig.cpu	2008-04-01 22:35:32.000000000 +0100
@@ -388,7 +388,7 @@ config X86_OOSTORE
 #
 config X86_P6_NOP
 	def_bool y
-	depends on (X86_64 || !X86_GENERIC) && (M686 || MPENTIUMII || MPENTIUMIII || MPENTIUMM || MCORE2 || MPENTIUM4)
+	depends on (X86_64 || !X86_GENERIC) && (M686 || MPENTIUMII || MPENTIUMIII || MPENTIUMM || MCORE2 || MPENTIUM4 || MPSC)
 
 config X86_TSC
 	def_bool y
