Return-Path: <linux-kernel-owner+w=401wt.eu-S1762289AbZGABE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762289AbZGABE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761504AbZGAAfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:12 -0400
Received: from kroah.org ([198.145.64.141]:60502 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759390AbZGAAfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:35:07 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:33 2009
Message-Id: <20090701002433.285649572@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 065/108] cfg80211: return immediately if num reg rules > NL80211_MAX_SUPP_REG_RULES
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=cfg80211-return-immediately-if-num-reg-rules-nl80211_max_supp_reg_rules.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit 4776c6e7f66f853011bc1fd6fe37fa63f0b6982c upstream.

This has no functional change except we save a kfree(rd) and
allows us to clean this code up a bit after this. We do
avoid an unnecessary kfree(NULL) but calling that was OK too.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/wireless/nl80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2385,7 +2385,7 @@ static int nl80211_set_reg(struct sk_buf
 			rem_reg_rules) {
 		num_rules++;
 		if (num_rules > NL80211_MAX_SUPP_REG_RULES)
-			goto bad_reg;
+			return -EINVAL;
 	}
 
 	if (!reg_is_valid_request(alpha2)) {


