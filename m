Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbZHMUIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbZHMUIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932153AbZHMT7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:59:40 -0400
Received: from kroah.org ([198.145.64.141]:41750 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932120AbZHMT7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:38 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:29 2009
Message-Id: <20090813195129.458122866@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 33/74] cfg80211: add two missing NULL pointer checks
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=cfg80211-add-two-missing-null-pointer-checks.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes@sipsolutions.net>

commit cd3468bad96c00b5a512f551674f36776129520e upstream.

These pointers can be NULL, the is_mesh() case isn't
ever hit in the current kernel, but cmp_ies() can be
hit under certain conditions.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/wireless/scan.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -118,7 +118,7 @@ static int cmp_ies(u8 num, u8 *ies1, siz
 
 	if (!ie1 && !ie2)
 		return 0;
-	if (!ie1)
+	if (!ie1 || !ie2)
 		return -1;
 
 	r = memcmp(ie1 + 2, ie2 + 2, min(ie1[1], ie2[1]));
@@ -171,6 +171,8 @@ static bool is_mesh(struct cfg80211_bss 
 	ie = find_ie(WLAN_EID_MESH_CONFIG,
 		     a->information_elements,
 		     a->len_information_elements);
+	if (!ie)
+		return false;
 	if (ie[1] != IEEE80211_MESH_CONFIG_LEN)
 		return false;
 


