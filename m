Return-Path: <linux-kernel-owner+w=401wt.eu-S1756940AbYFXJDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940AbYFXJDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 05:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbYFXJDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 05:03:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49168 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbYFXJDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 05:03:07 -0400
Message-ID: <4860B756.2040608@cn.fujitsu.com>
Date: Tue, 24 Jun 2008 16:59:02 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: Kay Sievers <kay.sievers@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] kobjects: Transmit return value of call_usermodehelper()
 to caller
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kobject_uevent_env() drops the return value of call_usermodehelper().
It will make upper caller, such as dm_send_uevents(), to lose error
information.

BTW, Previously kobject_uevent_env() transmitted return of
call_usermodehelper() to callers, but
commit	5f123fbd80f4f788554636f02bf73e40f914e0d6
"[PATCH] merge kobject_uevent and kobject_hotplug" removed it.

Signed-off-by: Wang Chen <wangchen@cn.fujitsu.com>
---
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



