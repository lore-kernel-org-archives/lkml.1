Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbYH1Qba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbYH1Qba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 12:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbYH1QbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 12:31:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:57856 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbYH1QbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 12:31:18 -0400
Message-ID: <48B6D28E.10006@kernel.org>
Date: Thu, 28 Aug 2008 18:30:06 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] uevent: don't pass envp_ext[] as format string in kobject_uevent_env()
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 28 Aug 2008 16:31:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kobject_uevent_env() uses envp_ext[] as verbatim format string which
can cause problems ranging from unexpectedly mangled string to oops if
a string in envp_ext[] contains substring which can be interpreted as
format.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 lib/kobject_uevent.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 3f91472..ca215bc 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -165,7 +165,7 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 	/* keys passed in from the caller */
 	if (envp_ext) {
 		for (i = 0; envp_ext[i]; i++) {
-			retval = add_uevent_var(env, envp_ext[i]);
+			retval = add_uevent_var(env, "%s", envp_ext[i]);
 			if (retval)
 				goto exit;
 		}
-- 
1.5.4.5

