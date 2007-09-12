Return-Path: <linux-kernel-owner+w=401wt.eu-S932746AbXILXoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746AbXILXoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 19:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbXILXoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 19:44:39 -0400
Received: from gw.goop.org ([64.81.55.164]:37538 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbXILXoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 19:44:38 -0400
Message-ID: <46E879EA.8010506@goop.org>
Date: Wed, 12 Sep 2007 16:44:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: [PATCH] xen: don't bother trying to set cr4
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Xen ignores all updates to cr4, and some versions will kill the domain
if you try to change its value.  Just ignore all changes.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Andi Kleen <ak@suse.de>

---
 arch/i386/xen/enlighten.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

===================================================================
--- a/arch/i386/xen/enlighten.c
+++ b/arch/i386/xen/enlighten.c
@@ -625,8 +625,8 @@ static unsigned long xen_read_cr2_direct
 
 static void xen_write_cr4(unsigned long cr4)
 {
-	/* never allow TSC to be disabled */
-	native_write_cr4(cr4 & ~X86_CR4_TSD);
+	/* Just ignore cr4 changes; Xen doesn't allow us to do
+	   anything anyway. */
 }
 
 static unsigned long xen_read_cr3(void)


