Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbZAWVEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbZAWVEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 16:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbZAWVEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 16:04:11 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:17908 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbZAWVEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 16:04:09 -0500
Message-ID: <497A30A9.60200@oracle.com>
Date: Fri, 23 Jan 2009 13:03:37 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: [PATCH] kmemtrace: fix printk format warnings
References: <20090123184826.f2c91472.sfr@canb.auug.org.au>
In-Reply-To: <20090123184826.f2c91472.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.497A30AC.00B4:SCFSTAT928724,ss=1,fgs=0
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
 
