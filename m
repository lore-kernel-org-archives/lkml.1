Return-Path: <linux-kernel-owner+w=401wt.eu-S1753829AbYJCWXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbYJCWXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 18:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbYJCWWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 18:22:55 -0400
Received: from www.tglx.de ([62.245.132.106]:41324 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509AbYJCWWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 18:22:54 -0400
Date: Sat, 4 Oct 2008 00:22:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Hugh Dickins <hugh@veritas.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc8 doubled times
In-Reply-To: <Pine.LNX.4.64.0810031104080.28598@blonde.site>
Message-ID: <alpine.LFD.2.00.0810040020300.4404@apollo>
References: <Pine.LNX.4.64.0810031104080.28598@blonde.site>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2008, Hugh Dickins wrote:
> Hi Thomas,
> 
> Please would you take another look at your -rc8 commit
> 302745699c1b675b5d2a1af87271de10e4d96b6a clockevents:
> check broadcast device not tick device.

Bummer. I can swear that I had a fix for this in the quilt queue
before I applied it to the git tree.

The correct fix is below.

Thanks for spotting this.

       tglx
---
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index bd70345..cb01cd8 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -235,7 +235,8 @@ static void tick_do_broadcast_on_off(void *why)
 	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
 		if (!cpu_isset(cpu, tick_broadcast_mask)) {
 			cpu_set(cpu, tick_broadcast_mask);
-			if (bc->mode == TICKDEV_MODE_PERIODIC)
+			if (tick_broadcast_device.mode ==
+			    TICKDEV_MODE_PERIODIC)
 				clockevents_shutdown(dev);
 		}
 		if (*reason == CLOCK_EVT_NOTIFY_BROADCAST_FORCE)
@@ -245,7 +246,8 @@ static void tick_do_broadcast_on_off(void *why)
 		if (!tick_broadcast_force &&
 		    cpu_isset(cpu, tick_broadcast_mask)) {
 			cpu_clear(cpu, tick_broadcast_mask);
-			if (bc->mode == TICKDEV_MODE_PERIODIC)
+			if (tick_broadcast_device.mode ==
+			    TICKDEV_MODE_PERIODIC)
 				tick_setup_periodic(dev, 0);
 		}
 		break;
