Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991Ab0AZXoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab0AZXoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754947Ab0AZXoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:44:19 -0500
Received: from kroah.org ([198.145.64.141]:35513 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754930Ab0AZXoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:44:17 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:32 2010
Message-Id: <20100126233932.023370052@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [85/98] cfg80211: fix channel setting for wext
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

commit 5f6120335c701ba07d5151206071f4d6ccaa684f upstream.

Patch fixes the bug at
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2139

Currently we cannot set the channel using wext extension
if we have already associated and disconnected. As
cfg80211_mgd_wext_siwfreq will not switch the channel if ssid is set.
This fixes it by clearing the ssid.
Following is the sequence which it tries to fix.
modprobe iwlagn
iwconfig wlan0 essid ""
ifconfig wlan0 down
iwconfig wlan0 chan X

wext is marked as deprecate.If we use nl80211 we can easily play with
setting the channel.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/wireless/sme.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -655,6 +655,7 @@ void __cfg80211_disconnected(struct net_
 	memset(&wrqu, 0, sizeof(wrqu));
 	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
 	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
+	wdev->wext.connect.ssid_len = 0;
 #endif
 }
 


