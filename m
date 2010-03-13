Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935349Ab0CMAau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:30:50 -0500
Received: from kroah.org ([198.145.64.141]:46567 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935263Ab0CMAa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:30:28 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:05 2010
Message-Id: <20100313002705.406148211@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:25:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [002/145] ARM: 5944/1: scsi: fix timer setup in fas216.c
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

commit b857df1acc634b18db1db2a40864af985100266e upstream.

mod_timer() takes an absolute time and not a delay as its argument.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/arm/fas216.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2516,7 +2516,7 @@ int fas216_eh_device_reset(struct scsi_c
 		if (info->scsi.phase == PHASE_IDLE)
 			fas216_kick(info);
 
-		mod_timer(&info->eh_timer, 30 * HZ);
+		mod_timer(&info->eh_timer, jiffies + 30 * HZ);
 		spin_unlock_irqrestore(&info->host_lock, flags);
 
 		/*


