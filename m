Return-Path: <linux-kernel-owner+w=401wt.eu-S1753059AbZJZPts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbZJZPts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 11:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbZJZPtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 11:49:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911AbZJZPtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 11:49:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] frv: Fix check on unsigned in do_signal()
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Roel Kluin <roel.kluin@gmail.com>,
       David Howells <dhowells@redhat.com>
Date: Mon, 26 Oct 2009 15:49:41 +0000
Message-ID: <20091026154941.14620.14234.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>

syscallno is unsigned

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/kernel/signal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/arch/frv/kernel/signal.c b/arch/frv/kernel/signal.c
index 6b0a2b6..0974c0e 100644
--- a/arch/frv/kernel/signal.c
+++ b/arch/frv/kernel/signal.c
@@ -527,7 +527,7 @@ static void do_signal(void)
 
 no_signal:
 	/* Did we come from a system call? */
-	if (__frame->syscallno >= 0) {
+	if (__frame->syscallno != -1) {
 		/* Restart the system call - no handlers present */
 		switch (__frame->gr8) {
 		case -ERESTARTNOHAND:

