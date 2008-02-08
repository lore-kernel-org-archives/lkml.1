Return-Path: <linux-kernel-owner+w=401wt.eu-S1755747AbYBHWpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747AbYBHWpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761553AbYBHWiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:38:22 -0500
Received: from qb-out-0506.google.com ([72.14.204.234]:13476 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763455AbYBHWiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:38:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oCvqjBtvi0idQgmC3bTAW9J48rg/tSUkftJjdoJARi0krqGHWyQMUVbOa5Xjrx7kH0STSlSRMKFPOjO8slWhTj2LQN1tfIELXDuPkgSgH7UuBcK/YUHt2DVakV4M2pn54kY2DKGd4hcxIJz816qbu4Si4i4fkmFBMvCX1a3PA7o=
Subject: Re: [PATCH] fix sparse warning from include/linux/mmzone.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <alpine.LFD.1.00.0802081401410.2896@woody.linux-foundation.org>
References: <1202417543.31361.5.camel@brick>
	 <20080208135154.ccdac0c1.akpm@linux-foundation.org>
	 <alpine.LFD.1.00.0802081401410.2896@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 14:38:12 -0800
Message-Id: <1202510292.8067.6.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/mmzone.h:640:22: warning: potentially expensive pointer subtraction

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Linus, something like the following?

 include/linux/mmzone.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 8d8d197..7ed2922 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -637,9 +637,10 @@ static inline int is_normal_idx(enum zone_type idx)
 static inline int is_highmem(struct zone *zone)
 {
 #ifdef CONFIG_HIGHMEM
-	int zone_idx = zone - zone->zone_pgdat->node_zones;
-	return zone_idx == ZONE_HIGHMEM ||
-		(zone_idx == ZONE_MOVABLE && zone_movable_is_highmem());
+	struct zone *base = zone->zone_pgdat->node_zones;
+
+	return zone == base + ZONE_HIGHMEM ||
+		(zone == base + ZONE_MOVABLE && zone_movable_is_highmem());
 #else
 	return 0;
 #endif
-- 
1.5.4.1219.g65b9



