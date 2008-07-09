Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419AbYGIQxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbYGIQxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 12:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbYGIQvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 12:51:36 -0400
Received: from relay1.sgi.com ([192.48.171.29]:53206 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751959AbYGIQvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 12:51:31 -0400
Message-Id: <20080709165130.815485000@polaris-admin.engr.sgi.com>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 09:51:40 -0700
From: Mike Travis <travis@sgi.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: [RFC 11/15] x86_64: Replace xxx_pda() operations in include_asm-x86_stackprotector_h
Content-Disposition: inline; filename=incl_pda_ops_include_asm-x86_stackprotector_h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * It is now possible to use percpu operations for pda access
    since the pda is in the percpu area. Drop the pda operations.

    Thus:

	read_pda     --> x86_read_percpu
	write_pda    --> x86_write_percpu
	add_pda (+1) --> x86_inc_percpu
	or_pda       --> x86_or_percpu

Based on linux-2.6.tip/master

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/asm-x86/stackprotector.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.tip.orig/include/asm-x86/stackprotector.h	2008-07-01 10:41:33.000000000 -0700
+++ linux-2.6.tip/include/asm-x86/stackprotector.h	2008-07-01 10:49:14.920355480 -0700
@@ -32,7 +32,7 @@ static __always_inline void boot_init_st
 	canary += tsc + (tsc << 32UL);
 
 	current->stack_canary = canary;
-	write_pda(stack_canary, canary);
+	x86_write_percpu(pda.stack_canary, canary);
 }
 
 #endif

-- 
