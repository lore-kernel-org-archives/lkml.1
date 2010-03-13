Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935776Ab0CMAf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:35:26 -0500
Received: from kroah.org ([198.145.64.141]:47078 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935501Ab0CMAcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:32:10 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:14 2010
Message-Id: <20100313002714.299272135@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:27:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tim Gardner <tim.gardner@canonical.com>,
       Patrick McHardy <kaber@trash.net>
Subject: [104/145] netfilter: xt_recent: fix false match
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Tim Gardner <tim.gardner@canonical.com>

commit 8ccb92ad41cb311e52ad1b1fe77992c7f47a3b63 upstream.

A rule with a zero hit_count will always match.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/xt_recent.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -260,7 +260,7 @@ recent_mt(const struct sk_buff *skb, con
 		for (i = 0; i < e->nstamps; i++) {
 			if (info->seconds && time_after(time, e->stamps[i]))
 				continue;
-			if (++hits >= info->hit_count) {
+			if (info->hit_count && ++hits >= info->hit_count) {
 				ret = !ret;
 				break;
 			}


