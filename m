Return-Path: <linux-kernel-owner+w=401wt.eu-S1762708AbZEHATW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762708AbZEHATW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758858AbZEHAKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:10:21 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:52710
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755213AbZEHAJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:09:58 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 4/8] xen: deal with NMI's use of IST too
Date: Thu,  7 May 2009 13:24:58 -0700
Message-Id: <1241727902-3176-5-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241727902-3176-1-git-send-email-jeremy@goop.org>
References: <1241727902-3176-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

NMI uses the IST, and Xen will also deal with it.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 9c6de48..852db47 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -451,7 +451,8 @@ static int cvt_gate_to_trap(int vector, const gate_desc *val,
 	else if (addr == (unsigned long)int3)
 		addr = (unsigned long)xen_int3;
 	else if (addr == (unsigned long)double_fault ||
-		 addr == (unsigned long)stack_segment) {
+		 addr == (unsigned long)stack_segment ||
+		 addr == (unsigned long)nmi) {
 		/* Don't need to handle these */
 		return 0;
 #ifdef CONFIG_X86_MCE
-- 
1.6.0.6

