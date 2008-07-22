Return-Path: <linux-kernel-owner+w=401wt.eu-S1760855AbYGVFpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760855AbYGVFpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:45:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757639AbYGVF03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:26:29 -0400
Received: from cantor.suse.de ([195.135.220.2]:54156 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757621AbYGVF02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:26:28 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Wang Chen <wangchen@cn.fujitsu.com>, Kay Sievers <kay.sievers@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 70/79] kobject: Transmit return value of call_usermodehelper() to caller
Date: Mon, 21 Jul 2008 22:19:34 -0700
Message-Id: <1216703983-21448-70-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Chen <wangchen@cn.fujitsu.com>

kobject_uevent_env() drops the return value of call_usermodehelper().
It will make upper caller, such as dm_send_uevents(), to lose error
information.

BTW, Previously kobject_uevent_env() transmitted return of
call_usermodehelper() to callers, but
commit	5f123fbd80f4f788554636f02bf73e40f914e0d6
"[PATCH] merge kobject_uevent and kobject_hotplug" removed it.

Signed-off-by: Wang Chen <wangchen@cn.fujitsu.com>
Cc: Kay Sievers <kay.sievers@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject_uevent.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 2fa545a..9f8d599 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -245,7 +245,8 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 		if (retval)
 			goto exit;
 
-		call_usermodehelper(argv[0], argv, env->envp, UMH_WAIT_EXEC);
+		retval = call_usermodehelper(argv[0], argv,
+					     env->envp, UMH_WAIT_EXEC);
 	}
 
 exit:
-- 
1.5.6.3

