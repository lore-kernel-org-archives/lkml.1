Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbZA2Vu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbZA2Vu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 16:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbZA2Vuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 16:50:50 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:24187 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbZA2Vuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 16:50:50 -0500
Message-ID: <49822479.9030908@oracle.com>
Date: Thu, 29 Jan 2009 13:49:45 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -next/mmotm/resend] kmemtrace: fix printk formats
References: <200901291030.n0TAUhRI003046@imap1.linux-foundation.org> <4981E86F.60909@oracle.com> <Pine.LNX.4.64.0901292234520.17617@anakin>
In-Reply-To: <Pine.LNX.4.64.0901292234520.17617@anakin>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4982247E.00C6:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> 
> %4zu?

Ugh, yes.  Thanks.
Here's the updated patch.

-- 
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
+	ret = trace_seq_printf(s, "%4zu   ", entry->bytes_req);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* Allocated */
-	ret = trace_seq_printf(s, "%4ld   ", entry->bytes_alloc);
+	ret = trace_seq_printf(s, "%4zu   ", entry->bytes_alloc);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
