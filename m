Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbZA1VqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbZA1VqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 16:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbZA1Vpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 16:45:34 -0500
Received: from www.tglx.de ([62.245.132.106]:45159 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbZA1Vpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 16:45:34 -0500
Message-Id: <20090128212709.159344214@linutronix.de>
References: <20090128211912.300823284@linutronix.de>
User-Agent: quilt/0.46-1
Date: Wed, 28 Jan 2009 21:29:08 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Carsten Emde <carsten.emde@osadl.org>,
       Carsten Emde <Carsten.Emde@osadl.org>
Subject: [patch-rt 1/4] ftrace: fix swapped nibbles in tracer raw hex output
Content-Disposition: inline;
	filename=fix-swapped-nibbles-in-tracer-raw-hex-output-backport-from-2-6-28-mainline.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

backport from 2.6.28 mainline

Signed-off-by: Carsten Emde <Carsten.Emde@osadl.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/trace/trace.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

Index: linux-2.6.26/kernel/trace/trace.c
===================================================================
--- linux-2.6.26.orig/kernel/trace/trace.c
+++ linux-2.6.26/kernel/trace/trace.c
@@ -421,7 +421,6 @@ trace_seq_putmem_hex(struct trace_seq *s
 {
 	unsigned char hex[HEX_CHARS];
 	unsigned char *data = mem;
-	unsigned char byte;
 	int i, j;
 
 	BUG_ON(len >= HEX_CHARS);
@@ -431,10 +430,8 @@ trace_seq_putmem_hex(struct trace_seq *s
 #else
 	for (i = len-1, j = 0; i >= 0; i--) {
 #endif
-		byte = data[i];
-
-		hex[j++] = hex2asc[byte & 0x0f];
-		hex[j++] = hex2asc[byte >> 4];
+		hex[j++] = hex_asc_hi(data[i]);
+		hex[j++] = hex_asc_lo(data[i]);
 	}
 	hex[j++] = ' ';
 

-- 

