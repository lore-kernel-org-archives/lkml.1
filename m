Return-Path: <linux-kernel-owner+w=401wt.eu-S932884AbZKFWfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884AbZKFWfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932561AbZKFWfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:35:47 -0500
Received: from kroah.org ([198.145.64.141]:56888 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932455AbZKFWXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:00 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:45 2009
Message-Id: <20091106221545.069595559@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       =?ISO-8859-15?q?Bj=C3=B6rn=20Smedman?= <bjorn.smedman@venatech.se>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [47/99] mac80211: fix for incorrect sequence number on hostapd injected frames
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=mac80211-fix-for-incorrect-sequence-number-on-hostapd-injected-frames.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Björn Smedman <bjorn.smedman@venatech.se>

commit 9b1ce526eb917c8b5c8497c327768130ee683392 upstream.

When hostapd injects a frame, e.g. an authentication or association
response, mac80211 looks for a suitable access point virtual interface
to associate the frame with based on its source address. This makes it
possible e.g. to correctly assign sequence numbers to the frames.

A small typo in the ethernet address comparison statement caused a
failure to find a suitable ap interface. Sequence numbers on such
frames where therefore left unassigned causing some clients
(especially windows-based 11b/g clients) to reject them and fail to
authenticate or associate with the access point. This patch fixes the
typo in the address comparison statement.

Signed-off-by: Björn Smedman <bjorn.smedman@venatech.se>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1478,7 +1478,7 @@ int ieee80211_master_start_xmit(struct s
 				if (sdata->vif.type != NL80211_IFTYPE_AP)
 					continue;
 				if (compare_ether_addr(sdata->dev->dev_addr,
-						       hdr->addr2)) {
+						       hdr->addr2) == 0) {
 					dev_hold(sdata->dev);
 					dev_put(odev);
 					osdata = sdata;


