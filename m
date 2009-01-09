Return-Path: <linux-kernel-owner+w=401wt.eu-S932547AbZAIXkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547AbZAIXkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758776AbZAIXjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:39:16 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:16262 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759540AbZAIXjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:39:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:to:from:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=cPyk+7QpeZYcJG3jw5MXkqgncNDgBMfGJdwJaB7V8LtUN6uI/yLWaLVAhyZzzJSJpC
         7luaz01pBySf8O2W+Q6Rv3emS1anLk4YKZw9SoxRvOT3v+pa7opXMgtXj/SAI/QrntIJ
         4j14B9PYYcZwRM2HnXmH0oBfFBXLhprwouvWM=
Subject: [PATCH 4/5] Fix dubious bitwise 'and' usage spotted by sparse.
To: LKML <linux-kernel@vger.kernel.org>
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Trivial Kernel Patches <trivial@kernel.org>
Date: Sat, 10 Jan 2009 02:48:21 +0300
Message-ID: <20090109234821.11800.74193.stgit@zaytsev.su>
In-Reply-To: <20090109234113.11800.55672.stgit@zaytsev.su>
References: <20090109234113.11800.55672.stgit@zaytsev.su>
User-Agent: StGit/0.14.3.292.gb975
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't change the semantics, but it looks like
the logical 'and' was meant to be used here.

Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
---
 drivers/net/wireless/ath9k/rc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index cca2fc5..e8eb20d 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -609,7 +609,7 @@ ath_rc_get_nextvalid_txrate(const struct ath_rate_table *rate_table,
 
 static int ath_rc_valid_phyrate(u32 phy, u32 capflag, int ignore_cw)
 {
-	if (WLAN_RC_PHY_HT(phy) & !(capflag & WLAN_RC_HT_FLAG))
+	if (WLAN_RC_PHY_HT(phy) && !(capflag & WLAN_RC_HT_FLAG))
 		return FALSE;
 	if (WLAN_RC_PHY_DS(phy) && !(capflag & WLAN_RC_DS_FLAG))
 		return FALSE;

