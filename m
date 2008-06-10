Return-Path: <linux-kernel-owner+w=401wt.eu-S1756368AbYFJHfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368AbYFJHfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 03:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbYFJHfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 03:35:33 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:35746 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752079AbYFJHfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 03:35:32 -0400
Date: Tue, 10 Jun 2008 16:35:32 +0900
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: jeremy@goop.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       xen-ia64-devel@lists.xensource.com,
       Samuel Thibault <samuel.thibault@eu.citrix.com>
Subject: [PATCH] xen: Use wmb instead of rmb in xen_evtchn_do_upcall().
Message-ID: <20080610073532.GG24381%yamahata@valinux.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is ported one from 534:77db69c38249 of linux-2.6.18-xen.hg.
Use wmb instead of rmb to enforce ordering between
evtchn_upcall_pending and evtchn_pending_sel stores
in xen_evtchn_do_upcall().

Cc: Samuel Thibault <samuel.thibault@eu.citrix.com>
Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
---
 drivers/xen/events.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 73d78dc..332dd63 100644
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
