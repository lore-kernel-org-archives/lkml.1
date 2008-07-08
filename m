Return-Path: <linux-kernel-owner+w=401wt.eu-S1759307AbYGHXTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307AbYGHXTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757604AbYGHXOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:14:49 -0400
Received: from gw.goop.org ([64.81.55.164]:51200 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755784AbYGHXOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:43 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 29 of 55] xen64: 64-bit starts using set_pte from very early
X-Mercurial-Node: e487727c7670491d09d3831ffe5c244eac745f4d
Message-Id: <e487727c7670491d09d3.1215554811@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It also doesn't need the 32-bit hack version of set_pte for initial
pagetable construction, so just make it use the real thing.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1194,7 +1194,11 @@
 	.kmap_atomic_pte = xen_kmap_atomic_pte,
 #endif
 
+#ifdef CONFIG_X86_64
+	.set_pte = xen_set_pte,
+#else
 	.set_pte = xen_set_pte_init,
+#endif
 	.set_pte_at = xen_set_pte_at,
 	.set_pmd = xen_set_pmd_hyper,
 


