Return-Path: <linux-kernel-owner+w=401wt.eu-S1758181AbZCQS4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181AbZCQS4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 14:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbZCQS4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 14:56:32 -0400
Received: from relay1.sgi.com ([192.48.179.29]:37295 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752691AbZCQS4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 14:56:31 -0400
To: mingo@elte.hu
Subject: Re: [PULL] x86 cpumask work
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, travis@sgi.com,
       steiner@sgi.com
Message-Id: <E1LjeSk-0004BW-3x@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Tue, 17 Mar 2009 13:56:30 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Cliff Wickman <cpw@sgi.com>

A patch on Mar13 2009 introduced a bug. I hope the below 1-line fix can
make the 'urgent' list, and get fixed before that patch moves on.

The Mar13 patch is saved at
http://marc.info/?l=linux-kernel&m=123683186504948&w=2

The allocation of per-cpu uv_flush_tlb_mask's in arch/x86/kernel/tlb_uv.c
changed a variable that should been reset to 0.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Acked-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/tlb_uv.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/arch/x86/kernel/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/tlb_uv.c	2009-03-16 11:14:40.000000000 -0500
+++ linux/arch/x86/kernel/tlb_uv.c	2009-03-16 11:15:38.000000000 -0500
@@ -777,6 +777,7 @@ static int __init uv_bau_init(void)
 	BUG_ON(!uv_bau_table_bases);
 
 	last_blade = -1;
+	cur_cpu = 0;
 	for_each_online_node(node) {
 		blade = uv_node_to_blade_id(node);
 		if (blade == last_blade)
