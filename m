Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbZAFWQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbZAFWQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbZAFWN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:13:27 -0500
Received: from kroah.org ([198.145.64.141]:51186 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753381AbZAFWNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:13:24 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/60] kobject: return the result of uevent sending by netlink
Date: Tue,  6 Jan 2009 14:11:27 -0800
Message-Id: <1231279939-32728-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

We need to return the result of uevent sending by netlink
to caller, when uevent_helper is disabled and CONFIG_NET
is defined.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject_uevent.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index ca215bc..318328d 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -225,8 +225,10 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 			}
 
 			NETLINK_CB(skb).dst_group = 1;
-			netlink_broadcast(uevent_sock, skb, 0, 1, GFP_KERNEL);
-		}
+			retval = netlink_broadcast(uevent_sock, skb, 0, 1,
+						   GFP_KERNEL);
+		} else
+			retval = -ENOMEM;
 	}
 #endif
 
-- 
1.6.0.4

