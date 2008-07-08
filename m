Return-Path: <linux-kernel-owner+w=401wt.eu-S1758392AbYGHXVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392AbYGHXVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757684AbYGHXOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:14:51 -0400
Received: from gw.goop.org ([64.81.55.164]:51219 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756385AbYGHXOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:44 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 26 of 55] xen: cpu_detect is 32-bit only
X-Mercurial-Node: 02f6689a370f4bcc31e37ea84efdc73d30778837
Message-Id: <02f6689a370f4bcc31e3.1215554808@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:48 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1365,12 +1365,12 @@
 	/* set the limit of our address space */
 	xen_reserve_top();
 
+#ifdef CONFIG_X86_32
 	/* set up basic CPUID stuff */
 	cpu_detect(&new_cpu_data);
-#ifdef CONFIG_X86_32
 	new_cpu_data.hard_math = 1;
+	new_cpu_data.x86_capability[0] = cpuid_edx(1);
 #endif
-	new_cpu_data.x86_capability[0] = cpuid_edx(1);
 
 	/* Poke various useful things into boot_params */
 	boot_params.hdr.type_of_loader = (9 << 4) | 0;


