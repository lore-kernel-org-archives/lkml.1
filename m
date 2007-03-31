Return-Path: <linux-kernel-owner+w=401wt.eu-S1753086AbXCaN7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbXCaN7W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 09:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbXCaN7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 09:59:22 -0400
Received: from verein.lst.de ([213.95.11.210]:52582 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076AbXCaN7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 09:59:22 -0400
Date: Sat, 31 Mar 2007 15:59:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] kprobes: use hlist_for_each_entry
Message-ID: <20070331135920.GA17406@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/kernel/kprobes.c
===================================================================
--- linux-2.6.orig/kernel/kprobes.c	2007-03-31 14:15:39.000000000 +0200
+++ linux-2.6/kernel/kprobes.c	2007-03-31 14:20:29.000000000 +0200
@@ -133,8 +133,7 @@ kprobe_opcode_t __kprobes *get_insn_slot
 	struct hlist_node *pos;
 
       retry:
-	hlist_for_each(pos, &kprobe_insn_pages) {
-		kip = hlist_entry(pos, struct kprobe_insn_page, hlist);
+	hlist_for_each_entry(kip, pos, &kprobe_insn_pages, hlist) {
 		if (kip->nused < INSNS_PER_PAGE) {
 			int i;
 			for (i = 0; i < INSNS_PER_PAGE; i++) {
@@ -213,9 +212,8 @@ static int __kprobes collect_garbage_slo
 	if (check_safety() != 0)
 		return -EAGAIN;
 
-	hlist_for_each_safe(pos, next, &kprobe_insn_pages) {
+	hlist_for_each_entry_safe(kip, pos, next, &kprobe_insn_pages, hlist) {
 		int i;
-		kip = hlist_entry(pos, struct kprobe_insn_page, hlist);
 		if (kip->ngarbage == 0)
 			continue;
 		kip->ngarbage = 0;	/* we will collect all garbages */
@@ -234,8 +232,7 @@ void __kprobes free_insn_slot(kprobe_opc
 	struct kprobe_insn_page *kip;
 	struct hlist_node *pos;
 
-	hlist_for_each(pos, &kprobe_insn_pages) {
-		kip = hlist_entry(pos, struct kprobe_insn_page, hlist);
+	hlist_for_each_entry(kip, pos, &kprobe_insn_pages, hlist) {
 		if (kip->insns <= slot &&
 		    slot < kip->insns + (INSNS_PER_PAGE * MAX_INSN_SIZE)) {
 			int i = (slot - kip->insns) / MAX_INSN_SIZE;
