Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbZJAXjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbZJAXjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756278AbZJAXiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:38:24 -0400
Received: from kroah.org ([198.145.64.141]:42071 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755981AbZJAXiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:38:19 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 16:33:22 2009
Message-Id: <20091001233322.057476155@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 16:31:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
       Patrick McHardy <kaber@trash.net>, davem@davemloft.net
Subject: [patch 22/30] netfilter: ebt_ulog: fix checkentry return value
References: <20091001233116.947658905@mini.kroah.org>
Content-Disposition: inline; filename=netfilter-ebt_ulog-fix-checkentry-return-value.patch
In-Reply-To: <20091001233504.GA17709@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Patrick McHardy <kaber@trash.net>

netfilter: ebt_ulog: fix checkentry return value

Upstream commit 8a56df0a:

Commit 19eda87 (netfilter: change return types of check functions for
Ebtables extensions) broke the ebtables ulog module by missing a return
value conversion.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/bridge/netfilter/ebt_ulog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -266,7 +266,7 @@ static bool ebt_ulog_tg_check(const stru
 	if (uloginfo->qthreshold > EBT_ULOG_MAX_QLEN)
 		uloginfo->qthreshold = EBT_ULOG_MAX_QLEN;
 
-	return 0;
+	return true;
 }
 
 static struct xt_target ebt_ulog_tg_reg __read_mostly = {


