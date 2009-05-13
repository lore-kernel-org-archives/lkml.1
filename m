Return-Path: <linux-kernel-owner+w=401wt.eu-S1761618AbZEMVXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761618AbZEMVXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 17:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756780AbZEMVXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 17:23:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:34621 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756645AbZEMVXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 17:23:05 -0400
Subject: [PATCH -tip] x86: ds.c fix invalid assignment
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Markus Metzger <markus.t.metzger@intel.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 14 May 2009 02:47:54 +0530
Message-Id: <1242249474.3364.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fixes following sparse warnings:
  CHECK   arch/x86/kernel/ds.c
arch/x86/kernel/ds.c:549:19: warning: incorrect type in argument 2 (invalid types)
arch/x86/kernel/ds.c:549:19:    expected bad type enum bts_field field
arch/x86/kernel/ds.c:549:19:    got int
arch/x86/kernel/ds.c:514:35: error: incompatible types for operation (*)
arch/x86/kernel/ds.c:514:35:    left side has type unsigned char static [unsigned] [toplevel] sizeof_ptr_field
arch/x86/kernel/ds.c:514:35:    right side has type bad type enum bts_field field
arch/x86/kernel/ds.c:514:7: error: invalid assignment
arch/x86/kernel/ds.c:514:35: error: incompatible types for operation (*)
arch/x86/kernel/ds.c:514:35:    left side has type unsigned char static [unsigned] [toplevel] sizeof_ptr_field
arch/x86/kernel/ds.c:514:35:    right side has type bad type enum bts_field field
arch/x86/kernel/ds.c:514:7: error: invalid assignment
arch/x86/kernel/ds.c:514:35: error: incompatible types for operation (*)
arch/x86/kernel/ds.c:514:35:    left side has type unsigned char static [unsigned] [toplevel] sizeof_ptr_field
arch/x86/kernel/ds.c:514:35:    right side has type bad type enum bts_field field
arch/x86/kernel/ds.c:514:7: error: invalid assignment
arch/x86/kernel/ds.c:514:35: error: incompatible types for operation (*)
arch/x86/kernel/ds.c:514:35:    left side has type unsigned char static [unsigned] [toplevel] sizeof_ptr_field
arch/x86/kernel/ds.c:514:35:    right side has type bad type enum bts_field field
arch/x86/kernel/ds.c:514:7: error: invalid assignment
arch/x86/kernel/ds.c:514:35: error: incompatible types for operation (*)
arch/x86/kernel/ds.c:514:35:    left side has type unsigned char static [unsigned] [toplevel] sizeof_ptr_field
arch/x86/kernel/ds.c:514:35:    right side has type bad type enum bts_field field
arch/x86/kernel/ds.c:514:7: error: invalid assignment
arch/x86/kernel/ds.c:514:35: error: incompatible types for operation (*)
arch/x86/kernel/ds.c:514:35:    left side has type unsigned char static [unsigned] [toplevel] sizeof_ptr_field
arch/x86/kernel/ds.c:514:35:    right side has type bad type enum bts_field field
arch/x86/kernel/ds.c:514:7: error: invalid assignment
arch/x86/kernel/ds.c:520:35: error: incompatible types for operation (*)
arch/x86/kernel/ds.c:520:35:    left side has type unsigned char static [unsigned] [toplevel] sizeof_ptr_field
arch/x86/kernel/ds.c:520:35:    right side has type bad type enum bts_field field
arch/x86/kernel/ds.c:520:7: error: invalid assignment
arch/x86/kernel/ds.c:520:35: error: incompatible types for operation (*)

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/ds.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index 48bfe13..ef42a03 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -509,15 +509,15 @@ enum bts_field {
 	bts_escape		= ((unsigned long)-1 & ~bts_qual_mask)
 };
 
-static inline unsigned long bts_get(const char *base, enum bts_field field)
+static inline unsigned long bts_get(const char *base, unsigned long field)
 {
 	base += (ds_cfg.sizeof_ptr_field * field);
 	return *(unsigned long *)base;
 }
 
-static inline void bts_set(char *base, enum bts_field field, unsigned long val)
+static inline void bts_set(char *base, unsigned long field, unsigned long val)
 {
-	base += (ds_cfg.sizeof_ptr_field * field);;
+	base += (ds_cfg.sizeof_ptr_field * field);
 	(*(unsigned long *)base) = val;
 }
 
-- 
1.6.0.6



