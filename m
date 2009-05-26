Return-Path: <linux-kernel-owner+w=401wt.eu-S1759224AbZEZXSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224AbZEZXSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759094AbZEZXSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:18:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53146 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758340AbZEZXSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:18:30 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 03/17] x86: MCE: Port K7 bank 0 quirk to 64bit mce code
Date: Wed, 27 May 2009 01:18:02 +0200
Message-Id: <5a2337a03ce794fe7cf69e338ffacacb3770797c.1243377662.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <86b35f6b0b17e1edc38fb5c3178967ffc4d1fa0a.1243377662.git.ak@linux.intel.com>
References: <1243379896-26869-1-git-send-email-andi@firstfloor.org>
 <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
 <86b35f6b0b17e1edc38fb5c3178967ffc4d1fa0a.1243377662.git.ak@linux.intel.com>
In-Reply-To: <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
References: <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Various K7 have broken bank 0s. Don't enable it by default

Port from the 32bit code.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 89c9d6b..26048b5 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -651,6 +651,12 @@ static void mce_cpu_quirks(struct cpuinfo_x86 *c)
 			 */
 			mce_bootlog = 0;
 		}
+		/*
+		 * Various K7s with broken bank 0 around. Always disable
+		 * by default.
+		 */
+		 if (c->x86 == 6)
+			bank[0] = 0;
 	}
 
 	if (c->x86_vendor == X86_VENDOR_INTEL) {
-- 
1.6.0.2

