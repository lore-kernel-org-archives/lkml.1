Return-Path: <linux-kernel-owner+w=401wt.eu-S1750761AbZDNGwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750761AbZDNGwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 02:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750812AbZDNGw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 02:52:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:41438 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbZDNGwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 02:52:25 -0400
Message-ID: <49E43282.1090607@kernel.org>
Date: Mon, 13 Apr 2009 23:51:46 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: remove (null) in /sys kernel_page_tables
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: clearnup

%p prints out 0x000000000000000 as (null)
so use %lx instead.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/dump_pagetables.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/mm/dump_pagetables.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/dump_pagetables.c
+++ linux-2.6/arch/x86/mm/dump_pagetables.c
@@ -161,13 +161,14 @@ static void note_page(struct seq_file *m
 		   st->current_address >= st->marker[1].start_address) {
 		const char *unit = units;
 		unsigned long delta;
+		int width = sizeof(unsigned long) * 2;
 
 		/*
 		 * Now print the actual finished series
 		 */
-		seq_printf(m, "0x%p-0x%p   ",
-			   (void *)st->start_address,
-			   (void *)st->current_address);
+		seq_printf(m, "0x%0*lx-0x%0*lx   ",
+			   width, st->start_address,
+			   width, st->current_address);
 
 		delta = (st->current_address - st->start_address) >> 10;
 		while (!(delta & 1023) && unit[1]) {
