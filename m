Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435Ab0AJKnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab0AJKnL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 05:43:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342Ab0AJKnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 05:43:10 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:33685 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab0AJKnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 05:43:09 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: davem@davemloft.net
Cc: adobriyan@gmail.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
       James Morris <jmorris@namei.org>,
       Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
       Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
Subject: [PATCH 1/1] NET: ipv6, remove unnecessary check
Date: Sun, 10 Jan 2010 11:43:03 +0100
Message-Id: <1263120183-16365-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.7
In-Reply-To: <20100110103528.GA4769@x200>
References: <20100110103528.GA4769@x200>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found a potential null dereference in snmp6_unregister_dev.
There is a check for idev being NULL, but it is dereferenced
earlier. But idev cannot be NULL when passed to
snmp6_unregister_dev, so remove the test.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: "Pekka Savola (ipv6)" <pekkas@netcore.fi>
Cc: James Morris <jmorris@namei.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: netdev@vger.kernel.org
---
 net/ipv6/proc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv6/proc.c b/net/ipv6/proc.c
index c9605c3..7b197b7 100644
--- a/net/ipv6/proc.c
+++ b/net/ipv6/proc.c
@@ -259,7 +259,7 @@ int snmp6_unregister_dev(struct inet6_dev *idev)
 	struct net *net = dev_net(idev->dev);
 	if (!net->mib.proc_net_devsnmp6)
 		return -ENOENT;
-	if (!idev || !idev->stats.proc_dir_entry)
+	if (!idev->stats.proc_dir_entry)
 		return -EINVAL;
 	remove_proc_entry(idev->stats.proc_dir_entry->name,
 			  net->mib.proc_net_devsnmp6);
-- 
1.6.5.7

