Return-Path: <linux-kernel-owner+w=401wt.eu-S932676AbZHDO36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676AbZHDO36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755454AbZHDO3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:29:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40611 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194AbZHDO3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:29:12 -0400
Message-Id: <20090804142710.150085378@suse.com>
User-Agent: quilt/0.47-14.9
Date: Tue, 04 Aug 2009 10:26:21 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: Greg KH <gregkh@suse.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 3/5] rtl8192su: fixup size comparison warning
References: <20090804142618.455591385@suse.com>
Content-Disposition: inline; filename=patches.rpmify/rtl8192su-size-warning
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 sizeof(val) returns type unsigned long. count is already unsigned long, so
 just use that. This fixes a compile warning.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---

 drivers/staging/rtl8192su/ieee80211/ieee80211_module.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c
@@ -304,7 +304,7 @@ static int store_debug_level(struct file
 			     unsigned long count, void *data)
 {
 	char buf[] = "0x00000000";
-	unsigned long len = min(sizeof(buf) - 1, (u32)count);
+	unsigned long len = min(sizeof(buf) - 1, count);
 	char *p = (char *)buf;
 	unsigned long val;
 


