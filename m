Return-Path: <linux-kernel-owner+w=401wt.eu-S1754321AbYFPNYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbYFPNYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 09:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757128AbYFPNYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 09:24:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:60029 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757105AbYFPNYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 09:24:01 -0400
To: torvalds@linux-foundation.org
Cc: jacmet@sunsite.dk, dhowells@redhat.com, k.shutemov@gmail.com,
       linux-kernel@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Date: Mon, 16 Jun 2008 12:24:17 +0100
In-Reply-To: <87abhl7eqo.fsf@macbook.be.48ers.dk>
Subject: [PATCH 4/4] Export <linux/a.out.h> to userspace again.
Message-Id: <E1K8EgP-0002HP-T3@pmac.infradead.org>
X-Bad-Reply: In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This seems to have been removed accidentally in commit
ed7b1889da256977574663689b598d88950bbd23, but wasn't supposed to have
been -- the original patch at http://lkml.org/lkml/2007/10/30/144 just
moved it from $(header-y) to $(unifdef-y)

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
---
 include/linux/Kbuild |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 93b9885..b6fbb25 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -166,6 +166,9 @@ unifdef-y += acct.h
 unifdef-y += adb.h
 unifdef-y += adfs_fs.h
 unifdef-y += agpgart.h
+ifeq ($(wildcard include/asm-$(SRCARCH)/a.out.h),include/asm-$(SRCARCH)/a.out.h)
+unifdef-y += a.out.h
+endif
 unifdef-y += apm_bios.h
 unifdef-y += atalk.h
 unifdef-y += atmdev.h
-- 
1.5.5.1

