Return-Path: <linux-kernel-owner+w=401wt.eu-S1757170AbYAHLXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170AbYAHLXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 06:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbYAHLXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 06:23:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbYAHLXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 06:23:32 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Label x86 do_fork_idle() with __cpuinit
To: sam@ravnborg.org, ariveira@gmail.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Tue, 08 Jan 2008 11:23:26 +0000
Message-ID: <20080108112326.6524.86229.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Label x86 do_fork_idle() with __cpuinit to avoid getting linker warnings when
it references fork_idle().  Also make it static.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/x86/kernel/smpboot_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index 500670c..aaf4e12 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -526,7 +526,7 @@ struct create_idle {
 	int cpu;
 };
 
-void do_fork_idle(struct work_struct *work)
+static void __cpuinit do_fork_idle(struct work_struct *work)
 {
 	struct create_idle *c_idle =
 		container_of(work, struct create_idle, work);

