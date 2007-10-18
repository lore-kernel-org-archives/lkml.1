Return-Path: <linux-kernel-owner+w=401wt.eu-S1765005AbXJRWMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765005AbXJRWMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 18:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765567AbXJRWLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 18:11:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765413AbXJRWLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 18:11:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       tony.luck@intel.com, Doug Chapman <dchapman@redhat.com>
Subject: [PATCH] ia64 vDSO vs --build-id
X-Zippy-Says: Yow!  I'm out of work...I could go into shock absorbers...or SCUBA GEAR!!
Message-Id: <20071018221108.638644D04E2@magilla.localdomain>
Date: Thu, 18 Oct 2007 15:11:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When gcc uses --build-id by default, the gate.lds.S linker script runs afoul
of the new note section and produces a bad DSO image.  This fixes it.

Signed-off-by: Roland McGrath <roland@redhat.com>

--- a/arch/ia64/kernel/gate.lds.S
+++ b/arch/ia64/kernel/gate.lds.S
@@ -20,6 +20,8 @@ SECTIONS
 	.gnu.version_d		: { *(.gnu.version_d) }
 	.gnu.version_r		: { *(.gnu.version_r) }
 
+	.note			: { *(.note*) }		:readable	:note
+
 	.dynamic		: { *(.dynamic) }	:readable	:dynamic
 
 	/*
@@ -83,6 +85,7 @@ PHDRS
 	epc		PT_LOAD	FILEHDR PHDRS	FLAGS(1);	/* PF_X */
 #endif
 	dynamic		PT_DYNAMIC		FLAGS(4);	/* PF_R */
+	note		PT_NOTE			FLAGS(4);	/* PF_R */
 	unwind		PT_IA_64_UNWIND;
 }
 
