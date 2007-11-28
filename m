Return-Path: <linux-kernel-owner+w=401wt.eu-S1759259AbXK1T0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbXK1T0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 14:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756272AbXK1T0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 14:26:11 -0500
Received: from excu-mxob-1.symantec.com ([198.6.49.12]:41110 "EHLO
	excu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216AbXK1T0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 14:26:10 -0500
Date: Wed, 28 Nov 2007 19:02:10 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm] printk trivial optimizations fix
Message-ID: <Pine.LNX.4.64.0711281900010.25292@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mm's printk has been showing "%p" in abominable upper case recently:
its trivial optimizations have changed the default from lower to upper,
so the 'p' case needs to enforce lower explicitly.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 lib/vsprintf.c |    1 +
 1 file changed, 1 insertion(+)

--- 2.6.24-rc3-mm2/lib/vsprintf.c	2007-11-28 12:42:26.000000000 +0000
+++ linux/lib/vsprintf.c	2007-11-28 17:01:20.000000000 +0000
@@ -525,6 +525,7 @@ int vsnprintf(char *buf, size_t size, co
 				continue;
 
 			case 'p':
+				flags |= SMALL;
 				if (field_width == -1) {
 					field_width = 2*sizeof(void *);
 					flags |= ZEROPAD;
