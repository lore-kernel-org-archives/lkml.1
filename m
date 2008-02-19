Return-Path: <linux-kernel-owner+w=401wt.eu-S1760050AbYBSS71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050AbYBSS71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 13:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759413AbYBSS67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 13:58:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756899AbYBSS66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 13:58:58 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/4] MN10300: Introduce barriers to replace removed volatiles
	in gdbstub
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
       dhowells@redhat.com
Date: Tue, 19 Feb 2008 18:58:54 +0000
Message-ID: <20080219185854.22304.50185.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080219185848.22304.75764.stgit@warthog.procyon.org.uk>
References: <20080219185848.22304.75764.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce into the MN10300 gdbstub a couple of barrier() calls to replace the
removed volatility of the input/output index variables for the Rx ring buffer.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/kernel/gdb-io-ttysm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/arch/mn10300/kernel/gdb-io-ttysm.c b/arch/mn10300/kernel/gdb-io-ttysm.c
index c545159..e94c25e 100644
--- a/arch/mn10300/kernel/gdb-io-ttysm.c
+++ b/arch/mn10300/kernel/gdb-io-ttysm.c
@@ -196,6 +196,7 @@ int gdbstub_io_rx_char(unsigned char *_ch, int nonblock)
 try_again:
 	/* pull chars out of the buffer */
 	ix = gdbstub_rx_outp;
+	barrier();
 	if (ix == gdbstub_rx_inp) {
 		if (nonblock)
 			return -EAGAIN;
@@ -207,6 +208,7 @@ try_again:
 
 	ch = gdbstub_rx_buffer[ix++];
 	st = gdbstub_rx_buffer[ix++];
+	barrier();
 	gdbstub_rx_outp = ix & (PAGE_SIZE - 1);
 
 	st &= SC01STR_RXF | SC01STR_RBF | SC01STR_FEF | SC01STR_PEF |

