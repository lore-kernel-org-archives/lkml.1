Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbZBPMtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbZBPMtf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 07:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754783AbZBPMt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 07:49:27 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55587 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635AbZBPMt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 07:49:27 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: __pte_to_swp_entry doesn't expand correctly
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, roel.kluin@gmail.com, linux-kernel@vger.kernel.org
Date: Mon, 16 Feb 2009 12:49:16 +0000
Message-ID: <20090216124916.25937.18753.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>

The macro doesn't expand correctly when its parameter isn't 'pte'.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/asm-frv/pgtable.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/include/asm-frv/pgtable.h b/include/asm-frv/pgtable.h
index 83c51ab..e16fdb1 100644
--- a/include/asm-frv/pgtable.h
+++ b/include/asm-frv/pgtable.h
@@ -478,7 +478,7 @@ static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 #define __swp_type(x)			(((x).val >> 2) & 0x1f)
 #define __swp_offset(x)			((x).val >> 8)
 #define __swp_entry(type, offset)	((swp_entry_t) { ((type) << 2) | ((offset) << 8) })
-#define __pte_to_swp_entry(pte)		((swp_entry_t) { (pte).pte })
+#define __pte_to_swp_entry(_pte)	((swp_entry_t) { (_pte).pte })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
 static inline int pte_file(pte_t pte)

