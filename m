Return-Path: <linux-kernel-owner+w=401wt.eu-S1758598AbYFYElO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbYFYElO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755223AbYFYEhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:20 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37441 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754093AbYFYEhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:15 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 08 of 36] x86_64: Add gate_offset() and gate_segment() macros
X-Mercurial-Node: 29449fe49ec728b2b1f5fe184b6d8f45adf453b1
Message-Id: <29449fe49ec728b2b1f5.1214367544@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:04 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For calculating the offset from struct gate_struct fields.

[ gate_offset and gate_segment were broken for 32-bit. ]

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/desc_defs.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/asm-x86/desc_defs.h b/include/asm-x86/desc_defs.h
--- a/include/asm-x86/desc_defs.h
+++ b/include/asm-x86/desc_defs.h
@@ -75,10 +75,14 @@
 typedef struct gate_struct64 gate_desc;
 typedef struct ldttss_desc64 ldt_desc;
 typedef struct ldttss_desc64 tss_desc;
+#define gate_offset(g) ((g).offset_low | ((unsigned long)(g).offset_middle << 16) | ((unsigned long)(g).offset_high << 32))
+#define gate_segment(g) ((g).segment)
 #else
 typedef struct desc_struct gate_desc;
 typedef struct desc_struct ldt_desc;
 typedef struct desc_struct tss_desc;
+#define gate_offset(g)		(((g).b & 0xffff0000) | ((g).a & 0x0000ffff))
+#define gate_segment(g)		((g).a >> 16)
 #endif
 
 struct desc_ptr {


