Return-Path: <linux-kernel-owner+w=401wt.eu-S1757780AbYGVFmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780AbYGVFmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757502AbYGVFZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:25:47 -0400
Received: from mx1.suse.de ([195.135.220.2]:54082 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757500AbYGVFZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:25:46 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Li Zefan <lizf@cn.fujitsu.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 61/79] kobject: should use kobject_put() in kset-example
Date: Mon, 21 Jul 2008 22:19:25 -0700
Message-Id: <1216703983-21448-61-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

We should call kobject_put() instead of kfree() if kobject_init_and_add()
returns an error, shouldn't we? Don't set up a bad example ;)

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 samples/kobject/kset-example.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/samples/kobject/kset-example.c b/samples/kobject/kset-example.c
index b0a1b4f..7395c0b 100644
--- a/samples/kobject/kset-example.c
+++ b/samples/kobject/kset-example.c
@@ -211,7 +211,7 @@ static struct foo_obj *create_foo_obj(const char *name)
 	 */
 	retval = kobject_init_and_add(&foo->kobj, &foo_ktype, NULL, "%s", name);
 	if (retval) {
-		kfree(foo);
+		kobject_put(&foo->kobj);
 		return NULL;
 	}
 
-- 
1.5.6.3

