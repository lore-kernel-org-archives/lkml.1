Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab0BSREw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:04:52 -0500
Received: from kroah.org ([198.145.64.141]:57824 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438Ab0BSRBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:01:13 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:54 2010
Message-Id: <20100219163254.275558369@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:30:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dave Airlie <airlied@redhat.com>
Subject: [84/93] drm/radeon/kms: use udelay for short delays
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 01d4503968f471f876fb44335800d2cf8dc5a2ce upstream.

For usec delays use udelay instead of scheduling, this should
allow reclocking to happen faster. This also was the cause
of reported 33s delays at bootup on certain systems.

fixes: freedesktop.org bug 25506

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/atom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/atom.c
+++ b/drivers/gpu/drm/radeon/atom.c
@@ -607,7 +607,7 @@ static void atom_op_delay(atom_exec_cont
 	uint8_t count = U8((*ptr)++);
 	SDEBUG("   count: %d\n", count);
 	if (arg == ATOM_UNIT_MICROSEC)
-		schedule_timeout_uninterruptible(usecs_to_jiffies(count));
+		udelay(count);
 	else
 		schedule_timeout_uninterruptible(msecs_to_jiffies(count));
 }


