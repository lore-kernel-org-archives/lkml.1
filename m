Return-Path: <linux-kernel-owner+w=401wt.eu-S1754994AbYHZFXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbYHZFXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 01:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYHZFXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 01:23:42 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:56703 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751096AbYHZFXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 01:23:41 -0400
Date: Tue, 26 Aug 2008 14:23:41 +0900
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       linux-ia64@vger.kernel.org, xen-devel@lists.xensource.com,
       xen-ia64-devel@lists.xensource.com
Subject: [PATCH] xen: compilation fix of drivers/xen/events.c on IA64
Message-ID: <20080826052341.GB1496%yamahata@valinux.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use set_xen_guest_handle() instead of direct assigning.

> linux-2.6/drivers/xen/events.c: In function 'xen_poll_irq':
> linux-2.6/drivers/xen/events.c:757: error: incompatible types in assignment
> make[4]: *** [drivers/xen/events.o] Error 1

Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
---
 drivers/xen/events.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index c3290bc..81e00ee 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -772,7 +772,7 @@ void xen_poll_irq(int irq)
 
 		poll.nr_ports = 1;
 		poll.timeout = 0;
-		poll.ports = &evtchn;
+		set_xen_guest_handle(poll.ports, &evtchn);
 
 		if (HYPERVISOR_sched_op(SCHEDOP_poll, &poll) != 0)
 			BUG();
-- 
1.6.0.rc0.42.g186458
