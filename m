Return-Path: <linux-kernel-owner+w=401wt.eu-S1030221AbXCCMth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030221AbXCCMth (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 07:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030227AbXCCMth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 07:49:37 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:22830 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030221AbXCCMtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 07:49:36 -0500
To: linux-kernel@vger.kernel.org
CC: gregkh@suse.de
Subject: [patch] kobject: new_device->kref wasn't putted in kobject_move()
From: Dmitriy Monakhov <dmonakhov@sw.ru>
Date: Sat, 03 Mar 2007 15:50:01 +0300
Message-ID: <87vehitrt2.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>

diff --git a/lib/kobject.c b/lib/kobject.c
index b94f208..b11f7b2 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -432,6 +432,7 @@ int kobject_move(struct kobject *kobj, struct kobject *new_parent)
 	kobject_put(old_parent);
 	kobject_uevent_env(kobj, KOBJ_MOVE, envp);
 out:
+	kobject_put(new_parent);
 	kobject_put(kobj);
 	kfree(devpath_string);
 	kfree(devpath);

