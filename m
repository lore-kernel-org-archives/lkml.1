Return-Path: <linux-kernel-owner+w=401wt.eu-S1751727AbYKPKXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbYKPKXo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 05:23:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbYKPKXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 05:23:36 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:54003 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbYKPKXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 05:23:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Ydqjahp2EoD6XNzwSh14YvDbky2xjZgGhVtK6H0+DmENMCQsQIt0VsmZJxBfowgrOR
         CTIjVFTEZKQLuzeqTdolXSU5BMgCnmGC0Z5QFloMYKSrDG59FPa0HHhCKez7K0wTsHdD
         TSb1uhAjzIVwFemQiL4X6tAqiWR3oQIfD/UpU=
From: tom.leiming@gmail.com
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] kobject: return the result of uevent sending by netlink
Date: Sun, 16 Nov 2008 18:23:27 +0800
Message-Id: <1226831007-6639-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

We need to return the result of uevent sending by netlink
to caller, when uevent_helper is disabled and CONFIG_NET
is defined.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 lib/kobject_uevent.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 3f91472..c1919d5 100644
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
1.6.0

