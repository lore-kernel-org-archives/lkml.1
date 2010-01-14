Return-Path: <linux-kernel-owner+w=401wt.eu-S1757012Ab0ANWbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012Ab0ANWbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756881Ab0ANWbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:31:13 -0500
Received: from kroah.org ([198.145.64.141]:60673 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756874Ab0ANW24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:28:56 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Felix Fietkau <nbd@openwrt.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 43/52] mac80211: add missing sanity checks for action frames
Date: Thu, 14 Jan 2010 14:27:22 -0800
Message-Id: <1263508051-7868-43-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-42-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
 <1263508051-7868-1-git-send-email-gregkh@suse.de>
 <1263508051-7868-2-git-send-email-gregkh@suse.de>
 <1263508051-7868-3-git-send-email-gregkh@suse.de>
 <1263508051-7868-4-git-send-email-gregkh@suse.de>
 <1263508051-7868-5-git-send-email-gregkh@suse.de>
 <1263508051-7868-6-git-send-email-gregkh@suse.de>
 <1263508051-7868-7-git-send-email-gregkh@suse.de>
 <1263508051-7868-8-git-send-email-gregkh@suse.de>
 <1263508051-7868-9-git-send-email-gregkh@suse.de>
 <1263508051-7868-10-git-send-email-gregkh@suse.de>
 <1263508051-7868-11-git-send-email-gregkh@suse.de>
 <1263508051-7868-12-git-send-email-gregkh@suse.de>
 <1263508051-7868-13-git-send-email-gregkh@suse.de>
 <1263508051-7868-14-git-send-email-gregkh@suse.de>
 <1263508051-7868-15-git-send-email-gregkh@suse.de>
 <1263508051-7868-16-git-send-email-gregkh@suse.de>
 <1263508051-7868-17-git-send-email-gregkh@suse.de>
 <1263508051-7868-18-git-send-email-gregkh@suse.de>
 <1263508051-7868-19-git-send-email-gregkh@suse.de>
 <1263508051-7868-20-git-send-email-gregkh@suse.de>
 <1263508051-7868-21-git-send-email-gregkh@suse.de>
 <1263508051-7868-22-git-send-email-gregkh@suse.de>
 <1263508051-7868-23-git-send-email-gregkh@suse.de>
 <1263508051-7868-24-git-send-email-gregkh@suse.de>
 <1263508051-7868-25-git-send-email-gregkh@suse.de>
 <1263508051-7868-26-git-send-email-gregkh@suse.de>
 <1263508051-7868-27-git-send-email-gregkh@suse.de>
 <1263508051-7868-28-git-send-email-gregkh@suse.de>
 <1263508051-7868-29-git-send-email-gregkh@suse.de>
 <1263508051-7868-30-git-send-email-gregkh@suse.de>
 <1263508051-7868-31-git-send-email-gregkh@suse.de>
 <1263508051-7868-32-git-send-email-gregkh@suse.de>
 <1263508051-7868-33-git-send-email-gregkh@suse.de>
 <1263508051-7868-34-git-send-email-gregkh@suse.de>
 <1263508051-7868-35-git-send-email-gregkh@suse.de>
 <1263508051-7868-36-git-send-email-gregkh@suse.de>
 <1263508051-7868-37-git-send-email-gregkh@suse.de>
 <1263508051-7868-38-git-send-email-gregkh@suse.de>
 <1263508051-7868-39-git-send-email-gregkh@suse.de>
 <1263508051-7868-40-git-send-email-gregkh@suse.de>
 <1263508051-7868-41-git-send-email-gregkh@suse.de>
 <1263508051-7868-42-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felix Fietkau <nbd@openwrt.org>

commit d79074488083ec0d7ecd15352192dc1631f25643 upstream.

Various missing sanity checks caused rejected action frames to be
interpreted as channel switch announcements, which can cause a client
mode interface to switch away from its operating channel, thereby losing
connectivity. This patch ensures that only spectrum management action
frames are processed by the CSA handling function and prevents rejected
action frames from getting processed by the MLME code.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/mac80211/mlme.c |    4 +++-
 net/mac80211/rx.c   |    4 ++++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index f13d181..6cae295 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1953,7 +1953,9 @@ static void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 			rma = ieee80211_rx_mgmt_disassoc(sdata, mgmt, skb->len);
 			break;
 		case IEEE80211_STYPE_ACTION:
-			/* XXX: differentiate, can only happen for CSA now! */
+			if (mgmt->u.action.category != WLAN_CATEGORY_SPECTRUM_MGMT)
+				break;
+
 			ieee80211_sta_process_chanswitch(sdata,
 					&mgmt->u.action.u.chan_switch.sw_elem,
 					ifmgd->associated);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 4e14754..674d8c2 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1808,6 +1808,10 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 		}
 		break;
 	default:
+		/* do not process rejected action frames */
+		if (mgmt->u.action.category & 0x80)
+			return RX_DROP_MONITOR;
+
 		return RX_CONTINUE;
 	}
 
-- 
1.6.6

