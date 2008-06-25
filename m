Return-Path: <linux-kernel-owner+w=401wt.eu-S1759426AbYFYEmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426AbYFYEmy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755709AbYFYEh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:26 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37455 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754656AbYFYEhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:17 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 27 of 36] x86_64: __switch_to(): Move
	arch_leave_lazy_cpu_mode() to the right place
X-Mercurial-Node: 2281dbcc167afedbee492af58721110a123c90f6
Message-Id: <2281dbcc167afedbee49.1214367563@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:23 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    We must leave lazy mode before switching the %fs and %gs selectors.

    (patch should be merged with previous
    __switch_to()/arch_leave_lazy_cpu_mode() patch)

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/process_64.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -603,6 +603,15 @@
 
 	load_TLS(next, cpu);
 
+	/*
+	 * Leave lazy mode, flushing any hypercalls made here.
+	 * This must be done before restoring TLS segments so
+	 * the GDT and LDT are properly updated, and must be
+	 * done before math_state_restore, so the TS bit is up
+	 * to date.
+	 */
+	arch_leave_lazy_cpu_mode();
+
 	/* 
 	 * Switch FS and GS.
 	 */


