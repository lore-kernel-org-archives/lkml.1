Return-Path: <linux-kernel-owner+w=401wt.eu-S1753785AbXDWPgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbXDWPgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 11:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbXDWPgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 11:36:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785AbXDWPgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 11:36:39 -0400
Date: Mon, 23 Apr 2007 11:36:30 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Antonino Daplas <adaplas@pol.net>
Subject: Prevent softlockup triggering in nvidiafb
Message-ID: <20070423151053.GA5653@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Antonino Daplas <adaplas@pol.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If the chip locks up, we get into a long polling loop,
where the softlockup detector kicks in.
See https://bugzilla.redhat.com/bugzilla/attachment.cgi?id=151878
for an example.

Signed-off-by: Dave Jones <davej@redhat.com>

--- linux-2.6.20.noarch/drivers/video/nvidia/nv_accel.c~	2007-04-23 11:06:12.000000000 -0400
+++ linux-2.6.20.noarch/drivers/video/nvidia/nv_accel.c	2007-04-23 11:07:18.000000000 -0400
@@ -132,6 +132,8 @@ static void NVDmaWait(struct nvidia_par 
 			}
 		} else
 			par->dmaFree = dmaGet - par->dmaCurrent - 1;
+
+		touch_softlockup_watchdog();
 	}
 
 	if (!count) {
