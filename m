Return-Path: <linux-kernel-owner+w=401wt.eu-S1758621AbYFPV7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621AbYFPV7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 17:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756544AbYFPV65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 17:58:57 -0400
Received: from gw.goop.org ([64.81.55.164]:38879 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756453AbYFPV64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 17:58:56 -0400
Message-ID: <4856E1F5.2000002@goop.org>
Date: Mon, 16 Jun 2008 14:58:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: the arch/x86 maintainers <x86@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Isaku Yamahata <yamahata@valinux.co.jp>,
       Samuel Thibault <samuel.thibault@eu.citrix.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: [PATCH] xen: Use wmb instead of rmb in xen_evtchn_do_upcall().
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Isaku Yamahata <yamahata@valinux.co.jp>

This patch is ported one from 534:77db69c38249 of linux-2.6.18-xen.hg.
Use wmb instead of rmb to enforce ordering between
evtchn_upcall_pending and evtchn_pending_sel stores
in xen_evtchn_do_upcall().

Cc: Samuel Thibault <samuel.thibault@eu.citrix.com>
Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
---
 drivers/xen/events.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

===================================================================
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -529,7 +529,7 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
 
 #ifndef CONFIG_X86 /* No need for a barrier -- XCHG is a barrier on x86. */
 		/* Clear master flag /before/ clearing selector flag. */
-		rmb();
+		wmb();
 #endif
 		pending_words = xchg(&vcpu_info->evtchn_pending_sel, 0);
 		while (pending_words != 0) {
-- 
1.5.3



