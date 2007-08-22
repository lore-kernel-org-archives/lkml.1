Return-Path: <linux-kernel-owner+w=401wt.eu-S1761531AbXHVJQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761531AbXHVJQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759922AbXHVJAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 05:00:11 -0400
Received: from 1wt.eu ([62.212.114.60]:2202 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759745AbXHVJAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 05:00:09 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084019.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:13 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Jean Tourrilhes <jt@hpl.hp.com>, Michael Buesch <mb@bu3sch.de>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 29/58] softmac: Fix ESSID problem
Content-Disposition: inline; filename=0029-softmac-Fix-ESSID-problem.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Victor Porton reported that the SoftMAC layer had random problem when setting the ESSID :
http://bugzilla.kernel.org/show_bug.cgi?id=8686 After investigation, it turned out to be
worse, the SoftMAC layer is left in an inconsistent state. The fix is pretty trivial.

Signed-off-by: Jean Tourrilhes <jt@hpl.hp.com>
Acked-by: Michael Buesch <mb@bu3sch.de>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Acked-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ieee80211/softmac/ieee80211softmac_assoc.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/ieee80211/softmac/ieee80211softmac_assoc.c b/net/ieee80211/softmac/ieee80211softmac_assoc.c
index a824852..dadb65c 100644
--- a/net/ieee80211/softmac/ieee80211softmac_assoc.c
+++ b/net/ieee80211/softmac/ieee80211softmac_assoc.c
@@ -271,8 +271,11 @@ ieee80211softmac_assoc_work(struct work_struct *work)
 			 */
 			dprintk(KERN_INFO PFX "Associate: Scanning for networks first.
");
 			ieee80211softmac_notify(mac->dev, IEEE80211SOFTMAC_EVENT_SCAN_FINISHED, ieee80211softmac_assoc_notify_scan, NULL);
-			if (ieee80211softmac_start_scan(mac))
+			if (ieee80211softmac_start_scan(mac)) {
 				dprintk(KERN_INFO PFX "Associate: failed to initiate scan. Is device up?
");
+				mac->associnfo.associating = 0;
+				mac->associnfo.associated = 0;
+			}
 			goto out;
 		} else {
 			mac->associnfo.associating = 0;
-- 
1.5.2.5

-- 
