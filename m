Return-Path: <linux-kernel-owner+w=401wt.eu-S1759014AbXIBT6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759014AbXIBT6i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 15:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbXIBT63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 15:58:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44545 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbXIBT62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 15:58:28 -0400
Date: Mon, 3 Sep 2007 01:41:34 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: John Linville <linville@tuxdriver.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       linux-wireless@vger.kernel.org
Subject: [PATCH -mm] net/wireless/sysfs.c: Shut up build warning
In-Reply-To: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.in>
Message-ID: <alpine.LFD.0.999.0709030139110.29617@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.i
 n>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="464262402-1192004133-1188763897=:29617"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--464262402-1192004133-1188763897=:29617
Content-Type: TEXT/PLAIN; charset=iso-2022-jp


net/wireless/sysfs.c:108: warning: ‘wiphy_uevent’ defined but not used

when CONFIG_HOTPLUG=n is because the only usage site of this function
is #ifdef'ed as such, so let's #ifdef the definition also.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 net/wireless/sysfs.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.23-rc4-mm1/net/wireless/sysfs.c~fix	2007-09-02 20:06:11.000000000 +0530
+++ linux-2.6.23-rc4-mm1/net/wireless/sysfs.c	2007-09-02 20:07:01.000000000 +0530
@@ -104,11 +104,13 @@ static void wiphy_dev_release(struct dev
 	cfg80211_dev_free(rdev);
 }
 
+#ifdef CONFIG_HOTPLUG
 static int wiphy_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	/* TODO, we probably need stuff here */
 	return 0;
 }
+#endif
 
 struct class ieee80211_class = {
 	.name = "ieee80211",
--464262402-1192004133-1188763897=:29617--
