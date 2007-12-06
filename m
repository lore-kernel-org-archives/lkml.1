Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655AbXLFQFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbXLFQFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 11:05:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbXLFQFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 11:05:04 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:59432 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbXLFQFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 11:05:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=I/qqhCqxAUhkfMDMmpMeP5agJA4wa8eceieo+DCMWOqXf/hYd1ZsQXeMEZOIDjoKUkOFCGxerImf9uAt441E6OtHDwQ68QiETFL+JgICeXiPTMyRQKNLgKaeaOQ7p2DL94/CRnJ9wTh8l8Dkjo5WIfGnBhKJU+K1UP7KQcunA98=
From: Denis Cheng <crquan@gmail.com>
To: netdev@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 14/20] net/ipv4/cipso_ipv4.c: use LIST_HEAD instead of LIST_HEAD_INIT
Date: Fri,  7 Dec 2007 00:04:36 +0800
Message-Id: <1196957076-5706-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

single list_head variable initialized with LIST_HEAD_INIT could almost
always can be replaced with LIST_HEAD declaration, this shrinks the code
and looks better.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 net/ipv4/cipso_ipv4.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index f18e88b..d4dc4eb 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -63,7 +63,7 @@ struct cipso_v4_domhsh_entry {
  * probably be turned into a hash table or something similar so we
  * can do quick lookups. */
 static DEFINE_SPINLOCK(cipso_v4_doi_list_lock);
-static struct list_head cipso_v4_doi_list = LIST_HEAD_INIT(cipso_v4_doi_list);
+static LIST_HEAD(cipso_v4_doi_list);
 
 /* Label mapping cache */
 int cipso_v4_cache_enabled = 1;
-- 
1.5.3.4

