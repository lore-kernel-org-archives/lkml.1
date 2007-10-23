Return-Path: <linux-kernel-owner+w=401wt.eu-S1752001AbXJWRrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbXJWRrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 13:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbXJWRr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 13:47:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46194 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbXJWRrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 13:47:25 -0400
Subject: Re: [RFC/PATCH 3/5] rt: plist_head_splice
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Daniel Walker <dwalker@mvista.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>, Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <Pine.LNX.4.58.0710231108050.31159@gandalf.stny.rr.com>
References: <20071023120357.782284000@chello.nl>
	 <20071023120745.122724000@chello.nl>
	 <Pine.LNX.4.58.0710231108050.31159@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Tue, 23 Oct 2007 19:45:42 +0200
Message-Id: <1193161542.5648.6.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Index: linux-2.6/lib/plist.c
===================================================================
--- linux-2.6.orig/lib/plist.c
+++ linux-2.6/lib/plist.c
@@ -167,8 +167,8 @@ void plist_head_splice(struct plist_head
 		list_del_init(&src_iter_first->plist.prio_list);
 
 		if (src_iter_first->prio < dst_iter->prio) {
-			list_add_tail(&src_iter_first->plist.node_list,
-					&dst_iter->plist.node_list);
+			list_add_tail(&src_iter_first->plist.prio_list,
+					&dst_iter->plist.prio_list);
 		} else if (src_iter_first->prio == dst_iter->prio) {
 			dst_iter = next_prio(dst_iter);
 		} else BUG();


