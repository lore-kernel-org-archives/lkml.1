Return-Path: <linux-kernel-owner+w=401wt.eu-S1757581AbZA2RfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbZA2RfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 12:35:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbZA2Rew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 12:34:52 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:46543 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632AbZA2Rew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 12:34:52 -0500
Message-ID: <4981E86F.60909@oracle.com>
Date: Thu, 29 Jan 2009 09:33:35 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH -next/mmotm/resend] kmemtrace: fix printk formats
References: <200901291030.n0TAUhRI003046@imap1.linux-foundation.org>
In-Reply-To: <200901291030.n0TAUhRI003046@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4981E872.012B:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kmemtrace printk warnings:

kernel/trace/kmemtrace.c:142: warning: format '%4ld' expects type 'long int', but argument 3 has type 'size_t'
kernel/trace/kmemtrace.c:147: warning: format '%4ld' expects type 'long int', but argument 3 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc:      Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 kernel/trace/kmemtrace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20090123.orig/kernel/trace/kmemtrace.c
+++ linux-next-20090123/kernel/trace/kmemtrace.c
@@ -139,12 +139,12 @@ kmemtrace_print_alloc_compress(struct tr
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* Requested */
-	ret = trace_seq_printf(s, "%4ld   ", entry->bytes_req);
+	ret = trace_seq_printf(s, "%4zd   ", entry->bytes_req);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* Allocated */
-	ret = trace_seq_printf(s, "%4ld   ", entry->bytes_alloc);
+	ret = trace_seq_printf(s, "%4zd   ", entry->bytes_alloc);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
