Return-Path: <linux-kernel-owner+w=401wt.eu-S1757433AbYEWNNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbYEWNNw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756136AbYEWNNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:13:14 -0400
Received: from gw.goop.org ([64.81.55.164]:33956 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756056AbYEWNNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:13:12 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 4 of 5] xen: allow some cr4 updates
X-Mercurial-Node: f0c894b6eba80461ec48db663f5a22660fdeb363
Message-Id: <f0c894b6eba80461ec48.1211548257@localhost>
In-Reply-To: <patchbomb.1211548253@localhost>
Date: Fri, 23 May 2008 14:10:57 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The guest can legitimately change things like cr4.OSFXSR and
OSXMMEXCPT, so let it.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -648,8 +648,10 @@
 
 static void xen_write_cr4(unsigned long cr4)
 {
-	/* Just ignore cr4 changes; Xen doesn't allow us to do
-	   anything anyway. */
+	cr4 &= ~X86_CR4_PGE;
+	cr4 &= ~X86_CR4_PSE;
+
+	native_write_cr4(cr4);
 }
 
 static unsigned long xen_read_cr3(void)


