Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbXLFEl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbXLFEl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 23:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbXLFElt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 23:41:49 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:35303 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbXLFEls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 23:41:48 -0500
Subject: [PATCH Latency Tracer] don't panic on failed bootmem alloc
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 05 Dec 2007 23:41:33 -0500
Message-Id: <1196916093.1645.41.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

This patch prevents a panic on a failed bootmem alloc in the
initialization of the tracer buffers.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>

Index: linux-2.6-latency/kernel/latency_trace.c
===================================================================
--- linux-2.6-latency.orig/kernel/latency_trace.c
+++ linux-2.6-latency/kernel/latency_trace.c
@@ -2720,10 +2720,11 @@ void * __init tracer_alloc_bootmem(unsig
 {
 	void * ret;
 
-	ret =__alloc_bootmem(size, SMP_CACHE_BYTES, ARCH_LOW_ADDRESS_LIMIT);
+	ret =__alloc_bootmem_nopanic(size, SMP_CACHE_BYTES,
+				     ARCH_LOW_ADDRESS_LIMIT);
 	if (ret != NULL && ((unsigned long)ret) < ARCH_LOW_ADDRESS_LIMIT) {
 		free_bootmem(__pa(ret), size);
-		ret = __alloc_bootmem(size,
+		ret = __alloc_bootmem_nopanic(size,
 				SMP_CACHE_BYTES,
 				__pa(MAX_DMA_ADDRESS));
 	}


