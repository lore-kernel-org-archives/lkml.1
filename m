Return-Path: <linux-kernel-owner+w=401wt.eu-S1756279AbZG2ADF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbZG2ADF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 20:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754590AbZG2ADC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 20:03:02 -0400
Received: from kroah.org ([198.145.64.141]:35648 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528AbZG1Xti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:49:38 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:52 2009
Message-Id: <20090728234152.435096195@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:40:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 08/71] cfg80211: fix refcount leak
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=cfg80211-fix-refcount-leak.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes@sipsolutions.net>

commit 2dce4c2b5f0b43bd25bf9ea6ded06b7f8a54c91f upstream.

The code in cfg80211's cfg80211_bss_update erroneously
grabs a reference to the BSS, which means that it will
never be freed.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/wireless/scan.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -365,7 +365,6 @@ cfg80211_bss_update(struct cfg80211_regi
 	found = rb_find_bss(dev, res);
 
 	if (found) {
-		kref_get(&found->ref);
 		found->pub.beacon_interval = res->pub.beacon_interval;
 		found->pub.tsf = res->pub.tsf;
 		found->pub.signal = res->pub.signal;


