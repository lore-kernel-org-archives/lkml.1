Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbYJOA6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbYJOA6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 20:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbYJOA4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 20:56:31 -0400
Received: from gw.goop.org ([64.81.55.164]:36867 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbYJOA42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 20:56:28 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 5 of 5] xen: compilation fix of drivers/xen/events.c
	on IA64
X-Mercurial-Node: 92ff3451f2c8697a5165f95395831d8813bdea86
Message-Id: <92ff3451f2c8697a5165.1224031844@abulafia.goop.org>
In-Reply-To: <patchbomb.1224031839@abulafia.goop.org>
Date: Tue, 14 Oct 2008 17:50:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Isaku Yamahata <yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Isaku Yamahata <yamahata@valinux.co.jp>

use set_xen_guest_handle() instead of direct assigning.

> linux-2.6/drivers/xen/events.c: In function 'xen_poll_irq':
> linux-2.6/drivers/xen/events.c:757: error: incompatible types in assignment
> make[4]: *** [drivers/xen/events.o] Error 1

Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/events.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -776,7 +776,7 @@
 
 		poll.nr_ports = 1;
 		poll.timeout = 0;
-		poll.ports = &evtchn;
+		set_xen_guest_handle(poll.ports, &evtchn);
 
 		if (HYPERVISOR_sched_op(SCHEDOP_poll, &poll) != 0)
 			BUG();


