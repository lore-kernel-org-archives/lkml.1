Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbZAFWP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbZAFWP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755024AbZAFWN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:13:26 -0500
Received: from kroah.org ([198.145.64.141]:51181 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753371AbZAFWNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:13:23 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/60] uevent: don't pass envp_ext[] as format string in kobject_uevent_env()
Date: Tue,  6 Jan 2009 14:11:26 -0800
Message-Id: <1231279939-32728-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

kobject_uevent_env() uses envp_ext[] as verbatim format string which
can cause problems ranging from unexpectedly mangled string to oops if
a string in envp_ext[] contains substring which can be interpreted as
format.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.6.0.4

